//
//  ZoomInAnimationController.swift
//  Movies
//
//  Created by Eugene Kurapov on 11.11.2020.
//

import UIKit

class ZoomInAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    var presenting = true
    var originFrame = CGRect.zero
    var destinationFrame = CGRect.zero
    var duration: TimeInterval = 1.0
        
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let targetView = transitionContext.view(forKey: .to) else { return }

        let initialFrame = originFrame
        let targetFrame = destinationFrame
        let xScale = initialFrame.width / targetFrame.width
        let yScale = initialFrame.height / targetFrame.height
        
        targetView.transform = CGAffineTransform(scaleX: xScale, y: yScale)
        let finalBounds = targetView.bounds
        let finalCenter = targetView.center
        targetView.bounds = targetFrame
        targetView.center = CGPoint(x: initialFrame.midX, y: initialFrame.midY)
        targetView.layer.cornerRadius = 20
        targetView.clipsToBounds = true

        containerView.addSubview(targetView)
        containerView.bringSubviewToFront(targetView)
        
        UIView.animate(withDuration: 0.7 * duration) {
            targetView.center = finalCenter
            targetView.transform = .identity
        }
        
        UIView.animate(withDuration: 0.7 * duration,
                       delay: 0.3 * duration,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 6/xScale,
                       options: .beginFromCurrentState) {
            targetView.bounds = finalBounds
        }
        
        UIView.animate(withDuration: 0.3 * duration, delay: 0.7 * duration, options: .beginFromCurrentState) {
            targetView.layer.cornerRadius = 0
        } completion: { _ in
            transitionContext.completeTransition(true)
        }
    }
    
}
