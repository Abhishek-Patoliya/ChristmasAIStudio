# Christmas AI Studio Backend Server

This is the secure backend service for **Christmas AI Studio** for iOS. It proxies image-generation requests to the OpenAI Images API so that client devices never store or expose OpenAI API keys.

## Quick Start

1. Install dependencies:
   ```bash
   cd backend
   npm install
   ```

2. Copy the environment variables:
   ```bash
   cp .env.example .env
   ```

3. Add your OpenAI API Key into `.env`:
   ```env
   OPENAI_API_KEY=sk-proj-your-openai-api-key-here
   PORT=8080
   OPENAI_IMAGE_MODEL=dall-e-3
   ```
   *(If no API key is supplied, the server automatically boots into **Mock Development Mode**, returning sample previews for local development and testing).*

4. Start the server:
   ```bash
   npm start
   ```

## Endpoints

- `GET /api/health`: Health status, active model, and OpenAI API key status.
- `POST /api/generate`: Submits reference image & style prompt, returning a job identifier.
- `GET /api/jobs/:id`: Polls job progress, status, and result image URL.
- `GET /api/images/:filename`: Securely serves rendered holiday images.
