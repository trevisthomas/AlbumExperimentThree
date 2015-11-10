//
//  GenreToAlbumAnimator.swift
//  AlbumExperimentThree
//
//  Created by Trevis Thomas on 11/9/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//

import UIKit

class GenreToAlbumAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    weak var transitionContext: UIViewControllerContextTransitioning?
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        
        let containerView = transitionContext.containerView()!
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)! //as! GenreViewController
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)! // as! AlbumViewController

        var view = UIView()
        view.frame = toViewController.view.frame
        view.backgroundColor = UIColor.whiteColor()
        view.alpha = 0
        
        containerView.addSubview(view)
        
        
        let stepTwo = {() -> Void in
            UIView.animateWithDuration(0.5, animations: {
                view.alpha = 0
                }) { arg in
                    view.removeFromSuperview()
                    transitionContext.completeTransition(true)
            }
        }
        
        UIView.animateWithDuration(0.5, animations: {
            // animating `transform` allows us to change 2D geometry of the object
            // like `scale`, `rotation` or `translate`
//            self.fish.transform = CGAffineTransformMakeRotation(fullRotation)
                view.alpha = 1
            }) {(param : Bool) -> Void in
                view.removeFromSuperview()
                containerView.addSubview(toViewController.view)
                containerView.addSubview(view)
                stepTwo()
                
//                transitionContext.completeTransition(true)
            }
        
        
        
        
//        UIView.ani
        
        

//        
//        let maskLayerAnimation = CABasicAnimation(keyPath: "path")
//                maskLayerAnimation.fromValue = circleMaskPathInitial.CGPath
//                maskLayerAnimation.toValue = circleMaskPathFinal.CGPath
//                maskLayerAnimation.duration = self.transitionDuration(transitionContext)
//               maskLayerAnimation.delegate = self
//                maskLayer.addAnimation(maskLayerAnimation, forKey: "path")
//        
        //1
//        self.transitionContext = transitionContext
        
//        //2
//        let containerView = transitionContext.containerView()!
//        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! ViewController
//        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! ViewController
//        let button = fromViewController.button
//        
//        //3
//        containerView.addSubview(toViewController.view)
//        
//        //4
//        let circleMaskPathInitial = UIBezierPath(ovalInRect: button.frame)
//        let extremePoint = CGPoint(x: button.center.x - 0, y: button.center.y - CGRectGetHeight(toViewController.view.bounds))
//        let radius = sqrt((extremePoint.x*extremePoint.x) + (extremePoint.y*extremePoint.y))
//        let circleMaskPathFinal = UIBezierPath(ovalInRect: CGRectInset(button.frame, -radius, -radius))
//        
//        //5
//        let maskLayer = CAShapeLayer()
//        maskLayer.path = circleMaskPathFinal.CGPath
//        toViewController.view.layer.mask = maskLayer
//        
//        //6
//        let maskLayerAnimation = CABasicAnimation(keyPath: "path")
//        maskLayerAnimation.fromValue = circleMaskPathInitial.CGPath
//        maskLayerAnimation.toValue = circleMaskPathFinal.CGPath
//        maskLayerAnimation.duration = self.transitionDuration(transitionContext)
//        maskLayerAnimation.delegate = self
//        maskLayer.addAnimation(maskLayerAnimation, forKey: "path")
        
        
    }
    
//    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
////        self.transitionContext?.completeTransition(!self.transitionContext!.transitionWasCancelled())
////        self.transitionContext?.viewControllerForKey(UITransitionContextFromViewControllerKey)?.view.layer.mask = nil
//        print("Ani did stop")
//    }

    
}
