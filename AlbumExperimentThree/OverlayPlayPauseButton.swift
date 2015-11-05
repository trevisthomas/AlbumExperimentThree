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
    @IBInspectable var topInset : CGFloat = 10
    @IBInspectable var radius : CGFloat = 20
    @IBInspectable var color : UIColor = UIColor.whiteColor()
    @IBInspectable var alphaOfTransparentArea : CGFloat = 0.6
    @IBInspectable var innerPadding : CGFloat = 4 //This inner padding is to make the triangle smaller than the inside of the circle.  Be careful chaning this.  If it's smaller than half of the radius bad things will happen
    
    override func drawRect(rect: CGRect) {
        // Drawing code
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context)
        
        let lineWidth = radius * 0.1 //Just making the outer circle 10% of the radius
        
        //Normalizing around 0,0
        let buttonRect = CGRect(x: -(radius + lineWidth) / 2, y: -radius / 2, width: radius, height: radius)
        //Draw the tinted circle
        let path = UIBezierPath(ovalInRect: buttonRect)
        let transparentColor = UIColor(red: 0, green: 0, blue: 0, alpha: alphaOfTransparentArea)
        transparentColor.setFill()

        //Outer circle
        path.lineWidth = lineWidth
        color.setStroke()

        //Move to position and draw the circle
        CGContextTranslateCTM(context, leftInset + ((radius+lineWidth)/2), topInset + ((radius+lineWidth)/2))
        path.fill()
        path.stroke()
        
        //Revert the context
        CGContextRestoreGState(context)
        //Save the context again so that it is restorable
        CGContextSaveGState(context)
        
        //Triangle
        let triPath = UIBezierPath()
        //Calculate the edge of the largest square that fits inside of the inner circle
        let innerRadius = (radius - 2 * lineWidth) - innerPadding
        let edge = sqrt((pow(innerRadius, 2.0)) / 2.0)
        triPath.moveToPoint(CGPoint(x: -edge/2, y: -edge/2))
        triPath.addLineToPoint(CGPoint(x: edge/2, y: 0))
        triPath.addLineToPoint(CGPoint(x: -edge/2, y: edge/2))
        triPath.closePath()
        color.setFill()
        
        //Move it into position
        CGContextTranslateCTM(context, leftInset + ((radius+lineWidth)/2), topInset + ((radius+lineWidth)/2))
        triPath.fill()
        CGContextRestoreGState(context)

    }
    

}
