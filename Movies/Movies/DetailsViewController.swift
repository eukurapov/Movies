//
//  DetailsViewController.swift
//  Movies
//
//  Created by Eugene Kurapov on 11.11.2020.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var movie: Movie? {
        didSet {
            imageView.image = nil
            if let movie = movie {
                activityIndicatior.startAnimating()
                nameLabel.text = movie.name
                subtitleLabel.text = movie.subtitle
                descriptionLabel.text = movie.description
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
    
    private var wrapper = UIView()
    private lazy var imageView = UIImageView()
    private lazy var nameLabel = UILabel.withTextStyle(.headline)
    private lazy var subtitleLabel = UILabel.withTextStyle(.caption1)
    private lazy var ratingLabel = UILabel.withTextStyle(.subheadline)
    private lazy var descriptionLabel = UILabel.withTextStyle(.body)
    private lazy var activityIndicatior = UIActivityIndicatorView()
    private var shadowLayer: CAShapeLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let panGestureRecogniser = UIPanGestureRecognizer(target: self, action: #selector(panGesture))
        view.addGestureRecognizer(panGestureRecogniser)
        
        style()
        layout()
    }
    
    private func style() {
        view.backgroundColor = .movieDarkPurple
        imageView.contentMode = .scaleAspectFill
        nameLabel.textColor = .white
        subtitleLabel.textColor = .white
        descriptionLabel.textColor = .white
        ratingLabel.textColor = .white
        ratingLabel.text = "★★★★★"
        activityIndicatior.color = .moviePurple
    }
    
    private func layout() {
        view.addSubview(wrapper)
        wrapper.addSubview(imageView)
        wrapper.addSubview(nameLabel)
        wrapper.addSubview(subtitleLabel)
        wrapper.addSubview(descriptionLabel)
        wrapper.addSubview(ratingLabel)
        wrapper.addSubview(activityIndicatior)
        wrapper.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatior.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalToSystemSpacingBelow: wrapper.topAnchor, multiplier: 1),
            imageView.leadingAnchor.constraint(equalToSystemSpacingAfter: wrapper.leadingAnchor, multiplier: 1),
            wrapper.trailingAnchor.constraint(equalToSystemSpacingAfter: imageView.trailingAnchor, multiplier: 1),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 9/16, constant: 0),
            
            imageView.bottomAnchor.constraint(equalToSystemSpacingBelow: subtitleLabel.bottomAnchor, multiplier: 2),
            subtitleLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: wrapper.leadingAnchor, multiplier: 2),
            wrapper.trailingAnchor.constraint(equalToSystemSpacingAfter: subtitleLabel.trailingAnchor, multiplier: 2),
            
            nameLabel.topAnchor.constraint(equalToSystemSpacingBelow: imageView.bottomAnchor, multiplier: 1),
            nameLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: wrapper.leadingAnchor, multiplier: 1),
            wrapper.trailingAnchor.constraint(equalToSystemSpacingAfter: nameLabel.trailingAnchor, multiplier: 1),
            
            ratingLabel.topAnchor.constraint(equalToSystemSpacingBelow: nameLabel.bottomAnchor, multiplier: 1),
            ratingLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: wrapper.leadingAnchor, multiplier: 1),
            wrapper.trailingAnchor.constraint(equalToSystemSpacingAfter: ratingLabel.trailingAnchor, multiplier: 1),
            
            descriptionLabel.topAnchor.constraint(equalToSystemSpacingBelow: ratingLabel.bottomAnchor, multiplier: 1),
            descriptionLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: wrapper.leadingAnchor, multiplier: 1),
            wrapper.trailingAnchor.constraint(equalToSystemSpacingAfter: descriptionLabel.trailingAnchor, multiplier: 1),
            
            activityIndicatior.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            activityIndicatior.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            
            wrapper.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            wrapper.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: wrapper.trailingAnchor),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: wrapper.bottomAnchor),
        ])
    }
    
    private func updateRatingMaskLayer() {
        let maskLayer = CAShapeLayer()
        let textRect = ratingLabel.textRect(forBounds: view.bounds, limitedToNumberOfLines: 1)
        let maskRect = CGRect(x: 0, y: 0,
                              width: textRect.width * CGFloat((movie?.rate ?? 0)/10),
                              height: textRect.height)
        maskLayer.path = UIBezierPath(rect: maskRect).cgPath
        ratingLabel.layer.mask = maskLayer
    }
    
    @objc
    private func panGesture(_ sender: UIPanGestureRecognizer) {
        let dY = sender.translation(in: wrapper).y
        
        guard dY > 0 else { return }
        
        let scale = 1 - (dY / wrapper.bounds.height)
        
        switch sender.state {
        case .changed:
            if scale < 0.85 {
                dismiss(animated: true)
            }
            wrapper.transform = CGAffineTransform(scaleX: scale, y: scale)
        case .ended, .cancelled:
            if scale < 0.85 {
                dismiss(animated: true)
            } else {
                UIView.animate(withDuration: 0.25) {
                    self.wrapper.transform = .identity
                }
            }
        default: break
        }
    }
    
}
