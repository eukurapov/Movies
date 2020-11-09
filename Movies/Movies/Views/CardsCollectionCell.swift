//
//  CardsCollectionCell.swift
//  Movies
//
//  Created by Eugene Kurapov on 09.11.2020.
//

import UIKit

class CardsCollectionCell: UITableViewCell {
    
    private var collection = MovieCardsCollection()
    
    convenience init(movies: [Movie]) {
        self.init()
        collection.movies = movies
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        layout()
    }
    
    private func layout() {
        contentView.addSubview(collection)
        collection.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collection.topAnchor.constraint(equalTo: contentView.topAnchor),
            collection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: collection.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: collection.bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
