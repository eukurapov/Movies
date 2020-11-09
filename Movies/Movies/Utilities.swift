//
//  Utilities.swift
//  Movies
//
//  Created by Eugene Kurapov on 09.11.2020.
//

import UIKit

extension UIColor {
    
    static var movieDarkPurple: UIColor {
        return UIColor(red: 26/255, green: 8/255, blue: 44/255, alpha: 1)
    }
    
    static var moviePurple: UIColor {
        return UIColor(red: 71/255, green: 5/255, blue: 102/255, alpha: 1)
    }
    
    static var movieLightPurple: UIColor {
        return UIColor(red: 129/255, green: 91/255, blue: 210/255, alpha: 1)
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
