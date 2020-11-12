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
    var transitionFrame = CGRect.zero
    var duration: TimeInterval = 1.0
    var onDismiss: (()->Void)?
        
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if presenting {
            animatePresenting(using: transitionContext)
        } else {
            animateDismissing(using: transitionContext)
        }
    }
    
    private func animatePresenting(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView

        guard let animatedView = transitionContext.view(forKey: .to) else { return }

        let initialFrame = originFrame
        let targetFrame = transitionFrame
        let xScale = initialFrame.width / targetFrame.width
        let yScale = initialFrame.height / targetFrame.height
        
        animatedView.transform = CGAffineTransform(scaleX: xScale, y: yScale)
        let finalBounds = animatedView.bounds
        let finalCenter = animatedView.center
        animatedView.bounds = targetFrame
        animatedView.center = CGPoint(x: initialFrame.midX, y: initialFrame.midY)
        animatedView.layer.cornerRadius = 20
        animatedView.clipsToBounds = true

        containerView.addSubview(animatedView)
        
        UIView.animate(withDuration: 0.7 * duration) {
            animatedView.center = finalCenter
            animatedView.transform = .identity
        }
        
        UIView.animate(withDuration: 0.7 * duration,
                       delay: 0.3 * duration,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 6/xScale,
                       options: .beginFromCurrentState) {
            animatedView.bounds = finalBounds
        }
        
        UIView.animate(withDuration: 0.3 * duration, delay: 0.7 * duration, options: .beginFromCurrentState) {
            animatedView.layer.cornerRadius = 0
        } completion: { _ in
            transitionContext.completeTransition(true)
        }
    }
    
    private func animateDismissing(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let animatedView = transitionContext.view(forKey: .from) else { return }

        let targetFrame = originFrame
        let intermediateFrame = transitionFrame
        let xScale = targetFrame.width / intermediateFrame.width
        let yScale = targetFrame.height / intermediateFrame.height
        
        containerView.addSubview(animatedView)

        UIView.animate(withDuration: 0.7 * duration) {
            animatedView.bounds = intermediateFrame
            animatedView.layoutIfNeeded()
        }
        
        UIView.animate(withDuration: 0.7 * duration,
                       delay: 0.3 * duration,
                       options: .beginFromCurrentState) {
            animatedView.center = CGPoint(x: targetFrame.midX, y: targetFrame.midY)
            animatedView.transform = CGAffineTransform.identity.scaledBy(x: xScale, y: yScale)
        } completion: { _ in
            self.onDismiss?()
            transitionContext.completeTransition(true)
        }
        
    }
    
}
