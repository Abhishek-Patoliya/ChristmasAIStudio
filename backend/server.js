/**
 * Christmas AI Studio - Secure Backend Service
 * Intermediary proxy communicating securely with OpenAI Images API.
 * Keeps API secrets off iOS client devices.
 */

const express = require('express');
const cors = require('cors');
const multer = require('multer');
const { v4: uuidv4 } = require('uuid');
const fs = require('fs');
const path = require('path');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 8080;
const OPENAI_API_KEY = process.env.OPENAI_API_KEY || '';
const OPENAI_IMAGE_MODEL = process.env.OPENAI_IMAGE_MODEL || 'dall-e-3';
const SERVER_BASE_URL = process.env.SERVER_BASE_URL || `http://localhost:${PORT}`;

// Storage directories
const UPLOADS_DIR = path.join(__dirname, 'temp_uploads');
const OUTPUTS_DIR = path.join(__dirname, 'outputs');

if (!fs.existsSync(UPLOADS_DIR)) fs.mkdirSync(UPLOADS_DIR, { recursive: true });
if (!fs.existsSync(OUTPUTS_DIR)) fs.mkdirSync(OUTPUTS_DIR, { recursive: true });

app.use(cors());
app.use(express.json());
app.use('/api/images', express.static(OUTPUTS_DIR));

// Multer memory/disk storage for uploaded reference photos
const upload = multer({
  dest: UPLOADS_DIR,
  limits: { fileSize: 15 * 1024 * 1024 }, // 15MB limit
});

// In-memory Job Queue
const jobs = new Map();

/**
 * Clean up older output images after 1 hour to respect user privacy
 */
setInterval(() => {
  const oneHourAgo = Date.now() - 60 * 60 * 1000;
  for (const [id, job] of jobs.entries()) {
    if (new Date(job.createdAt).getTime() < oneHourAgo) {
      if (job.localFilePath && fs.existsSync(job.localFilePath)) {
        try { fs.unlinkSync(job.localFilePath); } catch (e) {}
      }
      jobs.delete(id);
    }
  }
}, 15 * 60 * 1000);

// MARK: - Health Check
app.get('/api/health', (req, res) => {
  res.json({
    status: 'ok',
    service: 'Christmas AI Studio Backend',
    season: 'Holiday 2026',
    model: OPENAI_IMAGE_MODEL,
    hasApiKey: !!OPENAI_API_KEY,
    timestamp: new Date().toISOString()
  });
});

// MARK: - Submit Photo Generation
app.post('/api/generate', upload.single('image'), async (req, res) => {
  const { styleId, prompt, negativePrompt } = req.body;
  const imageFile = req.file;

  if (!prompt) {
    return res.status(400).json({ error: 'Missing prompt parameter' });
  }

  const jobId = uuidv4();
  const job = {
    id: jobId,
    status: 'processing',
    progress: 0.15,
    stepDescription: 'Analyzing facial features & lighting...',
    createdAt: new Date().toISOString(),
    resultImageURL: null,
    error: null,
    isMock: !OPENAI_API_KEY
  };

  jobs.set(jobId, job);

  // Return job immediately for async polling
  res.status(202).json(job);

  // Kick off background AI generation
  processGenerationJob(jobId, {
    styleId,
    prompt,
    negativePrompt,
    imagePath: imageFile ? imageFile.path : null
  });
});

// MARK: - Job Status Polling
app.get('/api/jobs/:id', (req, res) => {
  const job = jobs.get(req.params.id);
  if (!job) {
    return res.status(404).json({ error: 'Generation job not found' });
  }
  res.json(job);
});

/**
 * Background worker executing OpenAI API call
 */
async function processGenerationJob(jobId, { styleId, prompt, negativePrompt, imagePath }) {
  const job = jobs.get(jobId);
  if (!job) return;

  try {
    // If no OpenAI API Key configured, simulate realistic job steps
    if (!OPENAI_API_KEY) {
      console.log(`[Job ${jobId}] Running in Mock Development Mode (No OPENAI_API_KEY set)`);
      job.progress = 0.40;
      job.stepDescription = 'Applying festive holiday knitwear & textures...';
      await sleep(1500);

      job.progress = 0.70;
      job.stepDescription = 'Adding twinkling fairy lights & tree ornaments...';
      await sleep(1500);

      job.progress = 0.90;
      job.stepDescription = 'Polishing 4K holiday portrait...';
      await sleep(1000);

      // Create a fallback sample file
      const sampleFileName = `sample_${jobId}.jpg`;
      const samplePath = path.join(OUTPUTS_DIR, sampleFileName);
      
      // Copy uploaded image as preview or write minimal valid image
      if (imagePath && fs.existsSync(imagePath)) {
        fs.copyFileSync(imagePath, samplePath);
      } else {
        fs.writeFileSync(samplePath, Buffer.from([]));
      }

      job.status = 'completed';
      job.progress = 1.0;
      job.stepDescription = 'Complete!';
      job.resultImageURL = `${SERVER_BASE_URL}/api/images/${sampleFileName}`;
      job.localFilePath = samplePath;
      job.completedAt = new Date().toISOString();
      return;
    }

    // Real OpenAI API generation
    job.progress = 0.40;
    job.stepDescription = 'Submitting request to OpenAI Images engine...';

    const fullPrompt = `${prompt}. Natural facial geometry, high-end 85mm holiday photography, realistic skin textures. Avoid ${negativePrompt || 'blur, distortion'}.`;

    const openAiResponse = await fetch('https://api.openai.com/v1/images/generations', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${OPENAI_API_KEY}`
      },
      body: JSON.stringify({
        model: OPENAI_IMAGE_MODEL,
        prompt: fullPrompt,
        n: 1,
        size: '1024x1024',
        quality: 'hd',
        response_format: 'b64_json'
      })
    });

    if (!openAiResponse.ok) {
      const errText = await openAiResponse.text();
      console.error(`OpenAI error: ${errText}`);
      job.status = 'failed';
      job.error = `OpenAI API returned status ${openAiResponse.status}`;
      return;
    }

    const data = await openAiResponse.json();
    const b64Data = data.data[0].b64_json;
    const outputBuffer = Buffer.from(b64Data, 'base64');

    const outputFileName = `christmas_${jobId}.jpg`;
    const outputPath = path.join(OUTPUTS_DIR, outputFileName);
    fs.writeFileSync(outputPath, outputBuffer);

    // Remove temp uploaded photo immediately for privacy
    if (imagePath && fs.existsSync(imagePath)) {
      try { fs.unlinkSync(imagePath); } catch (e) {}
    }

    job.status = 'completed';
    job.progress = 1.0;
    job.stepDescription = 'Complete!';
    job.resultImageURL = `${SERVER_BASE_URL}/api/images/${outputFileName}`;
    job.localFilePath = outputPath;
    job.completedAt = new Date().toISOString();

  } catch (error) {
    console.error(`[Job ${jobId}] Failed:`, error);
    job.status = 'failed';
    job.error = error.message;
  }
}

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

app.listen(PORT, () => {
  console.log(`🎄 Christmas AI Studio Backend listening on http://localhost:${PORT}`);
  console.log(`🔒 Security: OpenAI API Key ${OPENAI_API_KEY ? 'CONFIGURED' : 'NOT SET (Mock Mode)'}`);
});
