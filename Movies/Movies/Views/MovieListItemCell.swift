//
//  MovieListItemCell.swift
//  Movies
//
//  Created by Eugene Kurapov on 10.11.2020.
//

import UIKit

class MovieListItemCell: UICollectionViewCell {
    
    static let identifier = "ListItemCell"
    
    var movie: Movie? {
        didSet {
            imageView.image = nil
            if let movie = movie {
                activityIndicatior.startAnimating()
                nameLabel.text = movie.name
                ratingLabel.text = String(repeating: "★", count: Int(5*movie.rate/10))
                MovieService.shared.fetchImageFrom(path: movie.imagePath) { [weak self] result in
                    self?.activityIndicatior.stopAnimating()
                    switch result {
                    case .success(let image):
                        self?.imageView.image = image
                    case .failure(let error):
                        self?.imageView.image = UIImage(named: "film.fill")
                        print(error)
                    }
                }
            }
        }
    }
    
    private lazy var imageView = UIImageView()
    private lazy var nameLabel = UILabel.withTextStyle(.subheadline)
    private lazy var ratingLabel = UILabel.withTextStyle(.footnote)
    private lazy var activityIndicatior = UIActivityIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        style()
        layout()
    }
    
    private func style() {
        imageView.contentMode = .scaleAspectFill
        nameLabel.textColor = .white
        ratingLabel.textColor = .white
        activityIndicatior.color = .moviePurple
        backgroundColor = .clear
    }
    
    private func layout() {
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(ratingLabel)
        contentView.addSubview(activityIndicatior)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatior.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 1),
            imageView.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 1),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 16/9, constant: 0),
            
            nameLabel.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 1),
            nameLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: imageView.trailingAnchor, multiplier: 1),
            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: nameLabel.trailingAnchor, multiplier: 1),
            
            ratingLabel.topAnchor.constraint(equalToSystemSpacingBelow: nameLabel.bottomAnchor, multiplier: 1),
            ratingLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: imageView.trailingAnchor, multiplier: 1),
            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: ratingLabel.trailingAnchor, multiplier: 1),
            
            contentView.bottomAnchor.constraint(equalToSystemSpacingBelow: imageView.bottomAnchor, multiplier: 1),
            
            activityIndicatior.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            activityIndicatior.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}