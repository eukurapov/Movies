//
//  MovieThumbnailCell.swift
//  Movies
//
//  Created by Eugene Kurapov on 10.11.2020.
//

import UIKit

class MovieThumbnailCell: UICollectionViewCell {
    
    static let identifier = "ThumbnailCell"
    
    var movie: Movie? {
        didSet {
            imageView.image = nil
            if let movie = movie {
                activityIndicatior.startAnimating()
                let path = movie.imagePath
                MovieService.shared.fetchImageFrom(path: path) { [weak self, path] result in
                    guard path == self?.movie?.imagePath else { return }
                    self?.activityIndicatior.stopAnimating()
                    switch result {
                    case .success(let image):
                        self?.imageView.image = image
                    case .failure(let error):
                        self?.imageView.image = UIImage(systemName: "film.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
                        print(error)
                    }
                }
            }
        }
    }
    
    lazy var imageView = UIImageView()
    private lazy var activityIndicatior = UIActivityIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        style()
        layout()
    }
    
    private func style() {
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        activityIndicatior.color = .moviePurple
        backgroundColor = .clear
    }
    
    private func layout() {
        contentView.addSubview(imageView)
        contentView.addSubview(activityIndicatior)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatior.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 1),
            imageView.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 1),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1, constant: 0),
            contentView.bottomAnchor.constraint(equalToSystemSpacingBelow: imageView.bottomAnchor, multiplier: 1),
            
            activityIndicatior.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            activityIndicatior.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addImageRoundedCorners()
    }
    
    private func addImageRoundedCorners() {
        let bezierPath = UIBezierPath(ovalIn: imageView.bounds)
        let maskLayer = CAShapeLayer()
        maskLayer.path = bezierPath.cgPath
        imageView.layer.mask = maskLayer
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
