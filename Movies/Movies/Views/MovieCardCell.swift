//
//  MovieCardCell.swift
//  Movies
//
//  Created by Eugene Kurapov on 09.11.2020.
//

import UIKit

class MovieCardCell: UICollectionViewCell {
    
    static let identifier = "CardCell"
    
    var movie: Movie? {
        didSet {
            imageView.image = nil
            if let movie = movie {
                activityIndicatior.startAnimating()
                nameLabel.text = movie.name
                subtitleLabel.text = movie.subtitle
                updateRatingMaskLayer()
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
    private lazy var nameLabel = UILabel.withTextStyle(.headline)
    private lazy var subtitleLabel = UILabel.withTextStyle(.caption1)
    private lazy var ratingLabel = UILabel.withTextStyle(.subheadline)
    private lazy var activityIndicatior = UIActivityIndicatorView()
    private var shadowLayer: CAShapeLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        style()
        layout()
    }
    
    private func style() {
        imageView.contentMode = .scaleAspectFill
        nameLabel.textColor = .white
        subtitleLabel.textColor = .white
        ratingLabel.textColor = .white
        ratingLabel.text = "★★★★★"
        activityIndicatior.color = .moviePurple
        backgroundColor = .clear
    }
    
    private func layout() {
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(ratingLabel)
        contentView.addSubview(activityIndicatior)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatior.translatesAutoresizingMaskIntoConstraints = false
        let contentViewBottomConstraint = contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        contentViewBottomConstraint.priority = .defaultHigh
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentViewBottomConstraint,
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            imageView.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 1),
            imageView.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 1),
            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: imageView.trailingAnchor, multiplier: 1),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 9/16, constant: 0),
            
            imageView.bottomAnchor.constraint(equalToSystemSpacingBelow: subtitleLabel.bottomAnchor, multiplier: 2),
            subtitleLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 2),
            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: subtitleLabel.trailingAnchor, multiplier: 2),
            
            nameLabel.topAnchor.constraint(equalToSystemSpacingBelow: imageView.bottomAnchor, multiplier: 1),
            nameLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 1),
            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: nameLabel.trailingAnchor, multiplier: 1),
            
            ratingLabel.topAnchor.constraint(equalToSystemSpacingBelow: nameLabel.bottomAnchor, multiplier: 1),
            ratingLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 1),
            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: ratingLabel.trailingAnchor, multiplier: 1),
            
            contentView.bottomAnchor.constraint(equalToSystemSpacingBelow: ratingLabel.bottomAnchor, multiplier: 1),
            
            activityIndicatior.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            activityIndicatior.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addImageRoundedCorners()
        addShadowLayer()
    }
    
    private func addImageRoundedCorners() {
        let bezierPath = UIBezierPath(roundedRect: imageView.bounds, cornerRadius: 10)
        let maskLayer = CAShapeLayer()
        maskLayer.path = bezierPath.cgPath
        imageView.layer.mask = maskLayer
    }
    
    private func addShadowLayer() {
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer!.shadowColor = UIColor.black.cgColor
            shadowLayer!.shadowOpacity = 1
            imageView.layer.insertSublayer(shadowLayer!, at: 0)
        }
        let shadowSize = imageView.bounds.height / 2
        guard shadowSize > 0 else { return }
        let contactRect = CGRect(x: -shadowSize,
                                 y: imageView.bounds.height - shadowSize/2,
                                 width: imageView.bounds.width + shadowSize*2,
                                 height: shadowSize)
        shadowLayer!.shadowPath = UIBezierPath(rect: contactRect).cgPath
        shadowLayer!.shadowRadius = shadowSize / 3
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateRatingMaskLayer() {
        let maskLayer = CAShapeLayer()
        let textRect = ratingLabel.textRect(forBounds: bounds, limitedToNumberOfLines: 1)
        let maskRect = CGRect(x: 0, y: 0,
                              width: textRect.width * CGFloat((movie?.rate ?? 0)/10),
                              height: textRect.height)
        maskLayer.path = UIBezierPath(rect: maskRect).cgPath
        ratingLabel.layer.mask = maskLayer
    }
    
}
