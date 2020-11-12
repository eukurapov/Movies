//
//  SectionHeader.swift
//  Movies
//
//  Created by Eugene Kurapov on 10.11.2020.
//

import UIKit

class SectionHeader: UICollectionReusableView {
    
    static let kind = "Header"
    static let identifier = "LargeTitle"
    
    var text: String? {
        didSet {
            label.text = text
        }
    }
    var textStyle: UIFont.TextStyle = .largeTitle {
        didSet {
            label.font = UIFont.preferredFont(forTextStyle: textStyle)
        }
    }
    private var label = UILabel.withTextStyle(.title2)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func style() {
        backgroundColor = .clear
        label.textColor = .movieText
    }
    
    private func layout() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 2),
            label.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 1),
            trailingAnchor.constraint(equalToSystemSpacingAfter: label.trailingAnchor, multiplier: 1),
            bottomAnchor.constraint(equalToSystemSpacingBelow: label.bottomAnchor, multiplier: 0),
        ])
    }
    
}
