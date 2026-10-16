import Foundation
import SwiftUI

public enum StyleCategory: String, CaseIterable, Identifiable, Codable {
    case santaLook = "Santa Look"
    case christmasPortrait = "Christmas Portrait"
    case winterWonderland = "Winter Wonderland"
    case cozyFireplace = "Cozy Fireplace"
    case coupleChristmas = "Couple Christmas"
    case familyHoliday = "Family Holiday"
    case christmasGreetingCards = "Christmas Greeting Cards"
    
    public var id: String { rawValue }
    
    public var systemIcon: String {
        switch self {
        case .santaLook: return "sparkles"
        case .christmasPortrait: return "person.crop.artframe"
        case .winterWonderland: return "snowflake"
        case .cozyFireplace: return "flame.fill"
        case .coupleChristmas: return "heart.fill"
        case .familyHoliday: return "person.3.fill"
        case .christmasGreetingCards: return "envelope.open.fill"
        }
    }
    
    public var subtitle: String {
        switch self {
        case .santaLook: return "Embody Santa or Mrs. Claus in luxury velvet"
        case .christmasPortrait: return "Studio holiday portraits with cinematic lighting"
        case .winterWonderland: return "Snowy evergreen forests and frosty magic"
        case .cozyFireplace: return "Warm hearthside knits and glowing embers"
        case .coupleChristmas: return "Romantic holiday moments under the mistletoe"
        case .familyHoliday: return "Joyful gatherings around the festive tree"
        case .christmasGreetingCards: return "Artistic portraits designed for holiday cards"
        }
    }
}

public struct ChristmasStyle: Identifiable, Hashable, Codable {
    public let id: String
    public let name: String
    public let category: StyleCategory
    public let description: String
    public let systemIcon: String
    public let basePrompt: String
    public let negativePrompt: String
    public let tag: String
    public let recommendedPhotoTip: String
    public let isPopular: Bool
    public let isNew: Bool
    
    public init(
        id: String,
        name: String,
        category: StyleCategory,
        description: String,
        systemIcon: String,
        basePrompt: String,
        negativePrompt: String = "distorted hands, duplicated people, extra fingers, cartoonish, blurry, artificial-looking face, text, watermarks, bad anatomy",
        tag: String = "Popular",
        recommendedPhotoTip: String = "Clear front-facing portrait with good lighting",
        isPopular: Bool = false,
        isNew: Bool = false
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.description = description
        self.systemIcon = systemIcon
        self.basePrompt = basePrompt
        self.negativePrompt = negativePrompt
        self.tag = tag
        self.recommendedPhotoTip = recommendedPhotoTip
        self.isPopular = isPopular
        self.isNew = isNew
    }
}

// MARK: - Built-in Christmas Styles Collection
public extension ChristmasStyle {
    static let allStyles: [ChristmasStyle] = [
        // MARK: - Santa Look
        ChristmasStyle(
            id: "santa_luxury_velvet",
            name: "Royal Velvet Santa",
            category: .santaLook,
            description: "Deep crimson tailored velvet coat with plush white fur trim, golden embroidery, and jolly twinkling eyes.",
            systemIcon: "crown.fill",
            basePrompt: "Transform the reference photograph into a premium, photorealistic portrait of the subject dressed in a luxurious royal Santa Claus coat made of rich crimson velvet with ornate gold embroidery and lush ivory fur trim. Preserve the subject's authentic facial identity, bone structure, expression, skin tone, and age. Surround with soft bokeh fairy lights, a dusting of snow on the shoulders, and warm golden holiday rim light. Cinematic, 85mm portrait lens, photorealistic skin texture.",
            tag: "Iconic",
            recommendedPhotoTip: "Solo photo looking straight or smiling gently",
            isPopular: true
        ),
        ChristmasStyle(
            id: "santa_workshop_artisan",
            name: "North Pole Artisan",
            category: .santaLook,
            description: "Charming vintage toy workshop setting with leather apron, festive flannel, and antique wooden toys.",
            systemIcon: "hammer.fill",
            basePrompt: "Transform the reference photo into an artisan North Pole workshop master portrait. The subject is in a warm, rustic wooden workshop surrounded by hand-carved wooden reindeer, glowing brass lanterns, and cedar shavings. Dressed in rich forest green and burgundy holiday knitwear with leather accents. Preserve realistic facial features, skin tone, eye color, and natural expression with high-end portrait lighting.",
            tag: "Vintage",
            recommendedPhotoTip: "Mid-chest to headshot photo"
        ),
        
        // MARK: - Christmas Portrait
        ChristmasStyle(
            id: "portrait_golden_glamour",
            name: "Golden Glamour Studio",
            category: .christmasPortrait,
            description: "Vogue-inspired editorial Christmas portrait with champagne gold bokeh and sparkling ornaments.",
            systemIcon: "camera.fill",
            basePrompt: "Transform the supplied reference photograph into a premium, photorealistic Christmas portrait. Preserve the subject's recognizable facial features, natural expression, skin tone, hairstyle, and approximate age as much as possible. Add elegant Christmas evening attire, warm fairy lights, a beautifully decorated Christmas tree with champagne and gold glass ornaments, cinematic lighting, realistic skin texture, and professional editorial portrait photography.",
            tag: "Trending",
            recommendedPhotoTip: "Well-lit portrait with clean background",
            isPopular: true
        ),
        ChristmasStyle(
            id: "portrait_emerald_velvet",
            name: "Emerald & Cashmere",
            category: .christmasPortrait,
            description: "Deep emerald green satin and creamy cashmere scarf surrounded by pine garland and candlelight.",
            systemIcon: "sparkle",
            basePrompt: "Transform reference photo into an exquisite holiday portrait dressed in tailored emerald green velvet and ivory cashmere. Natural warm candlelight ambiance, cedar garlands, pine cones with soft golden glitter, shallow depth of field, photorealistic, preserving subject's eyes, smile, and facial structure accurately.",
            tag: "Elegant",
            recommendedPhotoTip: "Frontal face with natural smile",
            isNew: true
        ),
        
        // MARK: - Winter Wonderland
        ChristmasStyle(
            id: "wonderland_frost_snowfall",
            name: "Alpine Snowfall",
            category: .winterWonderland,
            description: "Gentle falling snow, cozy chunky knit sweater, and frost-tipped pine trees in a mountain backdrop.",
            systemIcon: "snowflake",
            basePrompt: "Transform reference photograph into an outdoor winter wonderland scene with gentle snowflakes falling peacefully. The subject is wearing a high-end cream chunky wool turtleneck and a stylish festive holiday coat. Fluffy fresh snow on pine boughs in the soft background, rosy cheeks, natural warm breath in the crisp air, cinematic outdoor golden hour lighting, preserving facial likeness faithfully.",
            tag: "Festive",
            recommendedPhotoTip: "High-resolution photo with clear eyes",
            isPopular: true
        ),
        ChristmasStyle(
            id: "wonderland_ice_palace",
            name: "Silver Ice Palace",
            category: .winterWonderland,
            description: "Ethereal frosted crystal lanterns, silver evergreen branches, and gentle blue-gold illumination.",
            systemIcon: "wand.and.stars",
            basePrompt: "Transform reference photo into a majestic frosty winter wonderland with crystalline ice sculptures, glowing warm fairy lights wrapped around silver spruce trees, soft snowfall, luxurious silver and navy winter fashion, sharp focus on facial likeness, natural skin rendering.",
            tag: "Magical",
            recommendedPhotoTip: "Clear lighting without heavy shadows"
        ),
        
        // MARK: - Cozy Fireplace
        ChristmasStyle(
            id: "fireplace_hearth_glow",
            name: "Hearthside Glow",
            category: .cozyFireplace,
            description: "Warm stone hearth with crackling fire, stockings hung with care, and a steaming mug of cocoa.",
            systemIcon: "flame.fill",
            basePrompt: "Transform the reference photograph into a cozy Christmas fireside scene. The subject sits warmly by a majestic stone fireplace with roaring embers, stockings hanging from the rustic mantle, hot cocoa with marshmallows, wool holiday plaid blanket, warm amber light washing over the subject's face while preserving their exact facial features, natural smile, and age.",
            tag: "Cozy",
            recommendedPhotoTip: "Relaxed casual headshot",
            isPopular: true
        ),
        ChristmasStyle(
            id: "fireplace_cabin_retreat",
            name: "Midnight Cabin Retreat",
            category: .cozyFireplace,
            description: "Rustic log cabin, warm cedar walls, glowing string lights, and snow drifting outside the frosted window.",
            systemIcon: "house.lodge.fill",
            basePrompt: "Transform reference photograph into an intimate log cabin holiday portrait. Gentle firelight reflections, heavy knit holiday sweater, cedar garland along the mantle, illuminated Christmas tree in the corner, snow-covered forest outside the window pane, realistic photographic fidelity, accurate facial likeness.",
            tag: "Warm",
            recommendedPhotoTip: "Warm, friendly facial expression"
        ),
        
        // MARK: - Couple Christmas
        ChristmasStyle(
            id: "couple_mistletoe_romance",
            name: "Mistletoe Magic",
            category: .coupleChristmas,
            description: "Romantic Christmas evening, shared wool scarf, twinkling avenue lights, and mistletoe.",
            systemIcon: "heart.fill",
            basePrompt: "Transform the reference photo into a romantic holiday portrait. Dressed in matching coordinated Christmas knits and wool coats, gentle snowfall, warm string lights draped overhead, mistletoe accent, joyful holiday glow, preserving both subjects' facial identities, authentic smiles, and proportions accurately with photorealistic portrait photography.",
            tag: "Romantic",
            recommendedPhotoTip: "Photo with two people close together",
            isPopular: true
        ),
        ChristmasStyle(
            id: "couple_tree_decorating",
            name: "Trimming the Tree",
            category: .coupleChristmas,
            description: "Tender holiday moment placing the golden star on top of a grand illuminated balsam fir.",
            systemIcon: "star.fill",
            basePrompt: "Transform reference photo into a romantic couple decorating their Christmas tree. Holding a glowing golden tree-topper star, surrounded by wrapped gift boxes, cozy socks, twinkling Christmas tree lights reflecting gently, true-to-life facial preservation for both subjects.",
            tag: "Intimate",
            recommendedPhotoTip: "Couple facing camera or side-by-side"
        ),
        
        // MARK: - Family Holiday
        ChristmasStyle(
            id: "family_morning_presents",
            name: "Christmas Morning Joy",
            category: .familyHoliday,
            description: "Bright holiday morning around the tree, festive matching pajamas, ribbons, and gift unwrapping.",
            systemIcon: "gift.fill",
            basePrompt: "Transform the reference photo into a heartwarming, photorealistic family Christmas portrait. The subjects are gathered harmoniously by a grand decorated holiday tree with presents, ribbons, warm morning sunlight streaming in, festive red and green attire, genuine happiness, natural skin tones, accurately preserving individual facial likenesses and ages.",
            tag: "Heartfelt",
            recommendedPhotoTip: "Group photo with everyone's face visible",
            isPopular: true
        ),
        ChristmasStyle(
            id: "family_snowy_porch",
            name: "Festive Porch Gathering",
            category: .familyHoliday,
            description: "Snow-dusted front porch with cedar wreath, red bows, lantern glow, and holiday parkas.",
            systemIcon: "door.left.hand.open",
            basePrompt: "Transform reference photo into a joyful family holiday gathering on an idyllic snow-covered front porch adorned with fresh pine wreaths, red velvet ribbons, glowing iron lanterns, crisp winter atmosphere, sharp focus on all faces, authentic identity preservation.",
            tag: "Classic",
            recommendedPhotoTip: "Group portrait with even lighting"
        ),
        
        // MARK: - Christmas Greeting Cards
        ChristmasStyle(
            id: "card_illustrated_oil",
            name: "Classic Holiday Oil Painting",
            category: .christmasGreetingCards,
            description: "Rich Norman Rockwell-inspired holiday oil painting with warm rich brushstrokes and timeless charm.",
            systemIcon: "paintpalette.fill",
            basePrompt: "Transform reference photo into an elegant, painterly holiday portrait in the style of classic American Christmas oil paintings. Rich brushwork, golden glazed lights, dignified composition, warm palette of pine, garnet, and amber, subject's facial features and expression rendered with artistic fidelity suitable for a timeless holiday greeting card.",
            tag: "Card Art",
            recommendedPhotoTip: "Any clear portrait photo",
            isPopular: true
        ),
        ChristmasStyle(
            id: "card_vintage_postage",
            name: "Vintage North Pole Postcard",
            category: .christmasGreetingCards,
            description: "Nostalgic 1950s holiday print with festive border accents and warm sepia-tinted holiday glow.",
            systemIcon: "envelope.fill",
            basePrompt: "Transform reference photo into a warm nostalgic mid-century Christmas postcard portrait. Rich retro color grading, festive typography framing, subtle paper grain, vintage holiday ornaments, preserving realistic facial features with heartwarming holiday nostalgia.",
            tag: "Retro",
            recommendedPhotoTip: "Portrait with expressive face"
        )
    ]
}
