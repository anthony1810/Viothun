import UIKit

public extension UIImage {
    
    /// Resizes the image by a given percentage.
    ///
    /// - Parameters:
    ///   - percentage: The percentage by which to resize the image (e.g., 0.5 for 50% size).
    ///   - isOpaque: A Boolean value that determines whether the image is opaque.
    /// - Returns: A resized `UIImage` or `nil` if resizing fails.
    func resized(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }

    /// Resizes the image to fit within the specified width and height, preserving the aspect ratio.
    ///
    /// - Parameters:
    ///   - maxWidth: The maximum width allowed for the image.
    ///   - maxHeight: The maximum height allowed for the image.
    ///   - isOpaque: A Boolean value that determines whether the image is opaque.
    /// - Returns: A resized `UIImage` or the original image if it already fits the constraints, or `nil` if resizing fails.
    func resized(toFit maxWidth: CGFloat, maxHeight: CGFloat, isOpaque: Bool = true) -> UIImage? {
        // Calculate the aspect ratios
        let widthRatio = maxWidth / size.width
        let heightRatio = maxHeight / size.height
        let ratio = min(widthRatio, heightRatio)

        // Check if the current size is within bounds; if so, return the original image
        guard size.width > maxWidth || size.height > maxHeight else { return self }

        // Calculate the new canvas size using the ratio
        let canvasSize = CGSize(width: size.width * ratio, height: size.height * ratio)

        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvasSize, format: format).image { _ in
            draw(in: CGRect(origin: .zero, size: canvasSize))
        }
    }

    /// Resizes the image to a specified width while preserving the aspect ratio.
    ///
    /// - Parameters:
    ///   - width: The target width for the resized image.
    ///   - isOpaque: A Boolean value that determines whether the image is opaque.
    /// - Returns: A resized `UIImage` or `nil` if resizing fails.
    func resized(toWidth width: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: width, height: CGFloat(ceil(width / size.width * size.height)))
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }

    /// Resizes the image to a specific target size.
    ///
    /// - Parameter targetSize: The desired size for the image.
    /// - Returns: A resized `UIImage` or `nil` if resizing fails.
    func resizeImage(targetSize: CGSize) -> UIImage? {
        let size = self.size

        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height

        // Determine what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }

    /// Loads an image from a given file URL.
    ///
    /// - Parameter fileURL: The URL of the image file.
    /// - Returns: The `UIImage` loaded from the file, or `nil` if loading fails.
    static func load(fileURL: URL) -> UIImage? {
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            print("Error loading image : \(error)")
        }
        return nil
    }
}

extension UIImage {
    
    /// Rotates the image by a specified number of degrees.
    ///
    /// - Parameter degrees: The degrees to rotate the image by (e.g., 90 for a 90-degree clockwise rotation).
    /// - Returns: A new `UIImage` that is rotated, or `nil` if the rotation fails.
    func rotated(byDegrees degrees: CGFloat) -> UIImage? {
        // Convert degrees to radians
        let radians = degrees * .pi / 180

        // Calculate the new image size
        var newSize = CGRect(origin: CGPoint.zero, size: size)
            .applying(CGAffineTransform(rotationAngle: radians))
            .integral.size

        // Ensure the new size is positive
        newSize.width = abs(newSize.width)
        newSize.height = abs(newSize.height)

        // Create a new context of the new size to draw the rotated image
        UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }

        // Move the origin of the user coordinate system in the context to the middle
        context.translateBy(x: newSize.width / 2, y: newSize.height / 2)

        // Rotates the user coordinate system in the context
        context.rotate(by: radians)

        // Draw the image into the context
        draw(in: CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height))

        // Retrieve the rotated image from the context
        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()

        // Clean up the context
        UIGraphicsEndImageContext()

        return rotatedImage
    }
}
