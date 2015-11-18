//
//  UIView+Utils.swift
//  AlbumExperimentThree
//
//  Created by Trevis Thomas on 11/17/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//

import Foundation

extension UIView{
    
    //Bounds converted to screen coordinates.  I'm using this initially for animating view transitions
    func boundsOnScreen() -> CGRect{
        let origin = self.convertPoint(self.bounds.origin, toView: nil)
        let newRect = CGRect(origin: origin, size: self.bounds.size)
        return newRect
    }
}

