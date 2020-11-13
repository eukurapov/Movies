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
    lazy var imageView = UIImageView()
    private lazy var nameLabel = UILabel.withTextStyle(.headline)
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
        wrapper.layer.masksToBounds = true
        wrapper.backgroundColor = .movieDarkPurple
        view.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFill
        nameLabel.textColor = .movieText
        descriptionLabel.textColor = .movieText
        ratingLabel.textColor = .movieText
        ratingLabel.text = "★★★★★"
        activityIndicatior.color = .moviePurple
    }
    
    private func layout() {
        view.addSubview(wrapper)
        wrapper.addSubview(imageView)
        wrapper.addSubview(nameLabel)
        wrapper.addSubview(descriptionLabel)
        wrapper.addSubview(ratingLabel)
        wrapper.addSubview(activityIndicatior)
        wrapper.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatior.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: wrapper.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: wrapper.leadingAnchor),
            wrapper.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 9/16, constant: 0),
            
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
            
            wrapper.topAnchor.constraint(equalTo: view.topAnchor),
            wrapper.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: wrapper.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: wrapper.bottomAnchor),
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
            view.transform = CGAffineTransform(scaleX: scale, y: scale)
            wrapper.layer.cornerRadius = (1-scale/2)*20
        case .ended, .cancelled:
            if scale < 0.85 {
                dismiss(animated: true)
            } else {
                UIView.animate(withDuration: 0.25) {
                    self.view.transform = .identity
                    self.wrapper.layer.cornerRadius = 0
                }
            }
        default: break
        }
    }
    
}
