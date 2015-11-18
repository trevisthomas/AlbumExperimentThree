//
//  AlbumToSongAnimator.swift
//  AlbumExperimentThree
//
//  Created by Trevis Thomas on 11/17/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//

import UIKit

class AlbumToSongAnimator : NSObject, UIViewControllerAnimatedTransitioning {
    let duration : NSTimeInterval = 0.6
    weak var transitionContext: UIViewControllerContextTransitioning?
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        
        let containerView = transitionContext.containerView()!
//        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)! //as! GenreViewController
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!  as! SongViewController
        
        let solidColor = UIView()
        solidColor.frame = toViewController.view.frame
        solidColor.backgroundColor = toViewController.albumData.colorPalette.backgroundColor
        solidColor.alpha = 0
        
        let albumArtAnimationLayerView = UIView()
        albumArtAnimationLayerView.backgroundColor = UIColor.clearColor()
        albumArtAnimationLayerView.frame = toViewController.view.frame
        
        //The toViewController's view hasnt been drawn yet, you need to apply autolayout before using it's rect!!
        toViewController.view.layoutIfNeeded()
        //Hide the cover on the destination view so that you can be moving the new cover into place
        toViewController.albumCover.hidden = true

        //Create, setup and populate the albumArtImageView for animation
        let albumArtImageView = UIImageView()
        albumArtImageView.alpha = 0
        albumArtImageView.frame = toViewController.sourceAlbumCoverRect
        albumArtImageView.image = toViewController.albumCover.image
        albumArtAnimationLayerView.addSubview(albumArtImageView)
        
        //Load the two views that get animated
        containerView.addSubview(solidColor)
        containerView.addSubview(albumArtAnimationLayerView)
        
        
        let fadeOutSolidColor = {() -> Void in
            UIView.animateWithDuration(self.duration * 0.7,
                delay: 0.0,
                options: [.CurveEaseInOut, .AllowUserInteraction],
                animations: {
                    solidColor.alpha = 0
                },
                completion: {finished in
                    //Clean up and shut down
                    solidColor.removeFromSuperview()
                    albumArtAnimationLayerView.removeFromSuperview()
                    transitionContext.completeTransition(true)

            })
        }
        
        UIView.animateWithDuration(self.duration * 0.3, animations: {
            solidColor.alpha = 1
            albumArtImageView.alpha = 1
            }) {(param : Bool) -> Void in
                //Notice, below is not a mistake,  i am removing my two animation views, placing the toViewControler.view onto the stack and then readding my two animation views so that they are visible before i complete the animations!
                solidColor.removeFromSuperview()
                albumArtAnimationLayerView.removeFromSuperview()
                containerView.addSubview(toViewController.view)
                containerView.addSubview(solidColor)
                containerView.addSubview(albumArtAnimationLayerView)
                
                fadeOutSolidColor()
        }
        
        UIView.animateWithDuration(self.duration * 0.65,
            delay: 0.0,
            options: [.CurveEaseInOut, .AllowUserInteraction],
            animations: {
                albumArtImageView.frame = toViewController.albumCover.frame
            },
            completion: {finished in
                //Un hide the cover underneath when the cover animation is complete
                toViewController.albumCover.hidden = false
                
        })
        
    }

}