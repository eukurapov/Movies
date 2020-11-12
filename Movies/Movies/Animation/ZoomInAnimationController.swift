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
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeCubicPaced) {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.7) {
                targetView.center = finalCenter
                targetView.transform = .identity
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.5) {
                targetView.bounds = finalBounds
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.7, relativeDuration: 0.3) {
                targetView.layer.cornerRadius = 0
            }
            
        } completion: { _ in
            transitionContext.completeTransition(true)
        }
    }
    
}
