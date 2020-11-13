//
//  Utilities.swift
//  Movies
//
//  Created by Eugene Kurapov on 09.11.2020.
//

import UIKit

extension UIColor {
    
    static var movieText: UIColor {
        return .white
    }
    
    static var movieDarkPurple: UIColor {
        return UIColor(red: 26/255, green: 8/255, blue: 44/255, alpha: 1)
    }
    
    static var moviePurple: UIColor {
        return UIColor(red: 71/255, green: 5/255, blue: 102/255, alpha: 1)
    }
    
    static var movieLightPurple: UIColor {
        return UIColor(red: 129/255, green: 91/255, blue: 210/255, alpha: 1)
    }
    
    static var movieDarkPurpleSemiTransparent: UIColor {
        return UIColor(red: 71/255, green: 5/255, blue: 102/255, alpha: 0.5)
    }
    
}

extension UILabel {
    
    static func withTextStyle(_ style: UIFont.TextStyle, text: String? = nil, numberOfLines: Int = 0) -> UILabel {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: style)
        label.adjustsFontForContentSizeCategory = true
        label.text = text
        label.numberOfLines = numberOfLines
        return label
    }
    
}

extension UIImage {

    func decodedImage() -> UIImage {
        guard let cgImage = cgImage else { return self }
        let size = CGSize(width: cgImage.width, height: cgImage.height)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: cgImage.bytesPerRow, space: colorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        context?.draw(cgImage, in: CGRect(origin: .zero, size: size))
        guard let decodedImage = context?.makeImage() else { return self }
        return UIImage(cgImage: decodedImage)
    }
    
}
