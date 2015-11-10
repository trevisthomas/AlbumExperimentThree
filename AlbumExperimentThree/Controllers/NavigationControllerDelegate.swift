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
        return GenreToAlbumAnimatedTransitioning()
//        return nil
    }

}
