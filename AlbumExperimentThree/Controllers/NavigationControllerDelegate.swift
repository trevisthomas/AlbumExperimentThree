//
//  NavigationControllerDelegate.swift
//  AlbumExperimentThree
//
//  Created by Trevis Thomas on 11/9/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//

import UIKit

class NavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
    @IBOutlet weak var navigationController: UINavigationController?
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if toVC is SongViewController {
            return AlbumToSongAnimator()
        } else if fromVC is SongViewController {
            return AlbumToSongAnimator(reverse: true)
        } else {
            return GenreToAlbumAnimatedTransitioning()
        }
        
//        return GenreToAlbumAnimatedTransitioning()
//        return nil
    }
    


}
