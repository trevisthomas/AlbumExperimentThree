//
//  OverlayPlayPauseButton.swift
//  AlbumExperimentThree
//
//  Created by Trevis Thomas on 11/4/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//

import UIKit

@IBDesignable

class OverlayPlayPauseButton: UIButton {
    @IBInspectable var leftInset : CGFloat = 10
    @IBInspectable var topInset : CGFloat = 100
    @IBInspectable var radius : CGFloat = 20
    
    override func drawRect(rect: CGRect) {
        // Drawing code
        let buttonRect = CGRect(x: leftInset, y: topInset, width: radius, height: radius)
        var path = UIBezierPath(ovalInRect: buttonRect)
        UIColor.greenColor().setFill()
        path.fill()
    }
    

}
