import CoreImage
import CoreImage.CIFilterBuiltins
import UIKit

/// Utility to generate QR code images from arbitrary strings.
/// Uses CoreImage's `CIQRCodeGenerator`.
enum QRGenerator {
    static func generate(from string: String, scale: CGFloat = 10, correctionLevel: String = "M") -> UIImage? {
        let data = Data(string.utf8)
        let filter = CIFilter.qrCodeGenerator()
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue(correctionLevel, forKey: "inputCorrectionLevel")
        guard let outputImage = filter.outputImage else { return nil }
        let transformed = outputImage.transformed(by: CGAffineTransform(scaleX: scale, y: scale))
        let context = CIContext()
        if let cgImage = context.createCGImage(transformed, from: transformed.extent) {
            return UIImage(cgImage: cgImage)
        }
        return nil
    }
}