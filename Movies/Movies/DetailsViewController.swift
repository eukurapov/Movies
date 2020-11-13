//
//  DetailsViewController.swift
//  Movies
//
//  Created by Eugene Kurapov on 11.11.2020.
//

import UIKit

class DetailsViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool { return true }
    
    var movie: Movie? {
        didSet {
            imageView.image = nil
            if let movie = movie {
                activityIndicatior.startAnimating()
                nameLabel.text = movie.name
                descriptionLabel.text = movie.description + " " + movie.description
                updateRatingMaskLayer()
                MovieService.shared.fetchImageFrom(path: movie.imagePath) { [weak self] result in
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
    
    private var wrapper = UIScrollView()
    lazy var imageView = UIImageView()
    private lazy var nameLabel = UILabel.withTextStyle(.headline)
    private lazy var ratingLabel = UILabel.withTextStyle(.subheadline)
    private lazy var descriptionLabel = UILabel.withTextStyle(.body)
    private lazy var activityIndicatior = UIActivityIndicatorView()
    private var shadowLayer: CAShapeLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let panGestureRecogniser = UIPanGestureRecognizer(target: self, action: #selector(panGesture))
        panGestureRecogniser.delegate = self
        view.addGestureRecognizer(panGestureRecogniser)
        
        style()
        layout()
    }
    
    private func style() {
        modalPresentationCapturesStatusBarAppearance = true
        wrapper.layer.masksToBounds = true
        wrapper.backgroundColor = .movieDarkPurple
        wrapper.contentInsetAdjustmentBehavior = .never
        wrapper.showsVerticalScrollIndicator = false
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
            wrapper.topAnchor.constraint(equalTo: view.topAnchor),
            wrapper.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: wrapper.trailingAnchor),
            wrapper.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            
            imageView.topAnchor.constraint(equalTo: wrapper.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 9/16, constant: 0),
            
            nameLabel.topAnchor.constraint(equalToSystemSpacingBelow: imageView.bottomAnchor, multiplier: 1),
            nameLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: nameLabel.trailingAnchor, multiplier: 1),
            
            ratingLabel.topAnchor.constraint(equalToSystemSpacingBelow: nameLabel.bottomAnchor, multiplier: 1),
            ratingLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: ratingLabel.trailingAnchor, multiplier: 1),
            
            descriptionLabel.topAnchor.constraint(equalToSystemSpacingBelow: ratingLabel.bottomAnchor, multiplier: 1),
            descriptionLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: descriptionLabel.trailingAnchor, multiplier: 1),
            wrapper.bottomAnchor.constraint(equalTo: descriptionLabel.bottomAnchor),
            
            activityIndicatior.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            activityIndicatior.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            
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
        let dY = sender.translation(in: wrapper).y - wrapper.contentOffset.y
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

extension DetailsViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
