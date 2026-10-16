import XCTest
import UIKit
@testable import ChristmasAIStudio

final class ImageResizerTests: XCTestCase {
    
    func testImageDownscaling() {
        let largeSize = CGSize(width: 3000, height: 2000)
        UIGraphicsBeginImageContext(largeSize)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.red.cgColor)
        context?.fill(CGRect(origin: .zero, size: largeSize))
        let largeImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let resized = ImageResizer.resize(image: largeImage, maxDimension: 1024)
        XCTAssertLessThanOrEqual(resized.size.width, 1024)
        XCTAssertLessThanOrEqual(resized.size.height, 1024)
        XCTAssertEqual(resized.size.width, 1024)
        XCTAssertEqual(resized.size.height, round(1024.0 * (2000.0 / 3000.0)))
    }
    
    func testImageCompressionToJPEG() {
        let size = CGSize(width: 200, height: 200)
        UIGraphicsBeginImageContext(size)
        UIColor.green.setFill()
        UIGraphicsGetCurrentContext()?.fill(CGRect(origin: .zero, size: size))
        let img = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let jpegData = ImageResizer.compressToJPEG(image: img, quality: 0.8)
        XCTAssertNotNil(jpegData)
        XCTAssertGreaterThan(jpegData!.count, 0)
    }
}
