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
    let reverse : Bool
    weak var transitionContext: UIViewControllerContextTransitioning?
    
    init(reverse : Bool = false) {
        self.reverse = reverse
        super.init()
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        
        let containerView = transitionContext.containerView()!
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)! //as! GenreViewController
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        
        let songViewController = reverse ? fromViewController as! SongViewController : toViewController  as! SongViewController
        
        //The songViewController's view hasnt been drawn yet, you need to apply autolayout before using it's rect!!
        songViewController.view.layoutIfNeeded()
        
        
        let sourceRect = reverse ? songViewController.albumCover.frame : songViewController.sourceAlbumCoverRect
        let destRect = reverse ? songViewController.sourceAlbumCoverRect : songViewController.albumCover.frame
        let bgColor = songViewController.albumData.colorPalette.backgroundColor
        
        
        
        let solidColor = UIView()
        solidColor.frame = songViewController.view.frame
        solidColor.backgroundColor = bgColor
        solidColor.alpha = 0
        
        
        //The following adds the blurred cover to the solid color layer.  I think that this looks better.
        let blurredCoverView = UIImageView()
        blurredCoverView.image = songViewController.blurredCover.image
        blurredCoverView.frame = songViewController.blurredCover.frame
        solidColor.addSubview(blurredCoverView)

        
        let albumArtAnimationLayerView = UIView()
        albumArtAnimationLayerView.backgroundColor = UIColor.clearColor()
        albumArtAnimationLayerView.frame = songViewController.view.frame
        
        //Hide the cover on the destination view so that you can be moving the new cover into place
        
        if !reverse {
            songViewController.albumCover.hidden = true// !reverse // true
        }

        //Create, setup and populate the albumArtImageView for animation
        let albumArtImageView = UIImageView()
        albumArtImageView.alpha = 0
        albumArtImageView.frame = sourceRect
        albumArtImageView.image = songViewController.albumCover.image
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
//                    if !self.reverse {
//                       albumArtImageView.alpha = 0
//                    }
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
                
                if self.reverse {
                    songViewController.albumCover.hidden = true// !reverse // true
                }
                
                fadeOutSolidColor()
        }
        
        UIView.animateWithDuration(self.duration * 0.65,
            delay: 0.0,
            options: [.CurveEaseInOut, .AllowUserInteraction],
            animations: {
                albumArtImageView.frame = destRect
                if self.reverse {
                    albumArtImageView.alpha = 0
                }
            },
            completion: {finished in
                //Un hide the cover underneath when the cover animation is complete
                songViewController.albumCover.hidden = false
                
                
                
        })
        
    }

}