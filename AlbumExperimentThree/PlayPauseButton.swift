//
//  PlayPauseButton.swift
//  AlbumExperimentThree
//
//  Created by Trevis Thomas on 11/4/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//

import UIKit

@IBDesignable

class PlayPauseButton: UIButton {
    @IBInspectable var inset : CGFloat = 0
    @IBInspectable var isPlaying = false //Show as a play button
    @IBInspectable var color : UIColor = UIColor.orangeColor()
    
    
    override func drawRect(rect: CGRect) {
        
        //Triangle
        let triPath = UIBezierPath()
        let edge = min(rect.width, rect.height) - inset
        
        triPath.moveToPoint(CGPoint(x: -edge/2, y: -edge/2))
        triPath.addLineToPoint(CGPoint(x: edge/2, y: 0))
        triPath.addLineToPoint(CGPoint(x: -edge/2, y: edge/2))
        triPath.closePath()
        color.setFill()
        
        CGContextTranslateCTM(UIGraphicsGetCurrentContext(), inset/2 + edge/2,  inset/2 + edge/2)
        triPath.fill()
        
        
    }
}
