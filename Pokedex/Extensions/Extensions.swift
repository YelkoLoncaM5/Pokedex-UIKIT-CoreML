//
//  Extensions.swift
//  Pokedex
//
//  Created by Yelko Andrej Loncarich Manrique on 18/03/24.
//

import UIKit

extension UIImage {
    
    var cgOrientation: CGImagePropertyOrientation {
        return CGImagePropertyOrientation(rawValue: UInt32(self.imageOrientation.rawValue))!
    }
    
    func scaleImage(toSize newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? self
    }
    
    func cropToSquare() -> UIImage? {
        var cropRect: CGRect
        if let cgImage = self.cgImage {
            let contextSize = CGSize(width: cgImage.width, height: cgImage.height)
            if contextSize.width > contextSize.height {
                cropRect = CGRect(
                    x: (contextSize.width - contextSize.height) / 2,
                    y: 0,
                    width: contextSize.height,
                    height: contextSize.height
                )
            } else {
                cropRect = CGRect(
                    x: 0,
                    y: (contextSize.height - contextSize.width) / 2,
                    width: contextSize.width,
                    height: contextSize.width
                )
            }
            if let croppedCgImage = cgImage.cropping(to: cropRect) {
                return UIImage(
                    cgImage: croppedCgImage,
                    scale: 0,
                    orientation: self.imageOrientation
                )
            }
        }
        return nil
    }
    
}
