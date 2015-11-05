//
//  NextPreviousButton.swift
//  AlbumExperimentThree
//
//  Created by Trevis Thomas on 11/4/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//

import UIKit

@IBDesignable
class NextPreviousButton: UIButton {

    @IBInspectable var inset : CGFloat = 0
    @IBInspectable var isPrevious : Bool = false //Show as a previous track button
    @IBInspectable var color : UIColor = UIColor.orangeColor()
    
    
    override func drawRect(rect: CGRect) {
        
        let edge = min(rect.width, rect.height) - inset
       
        let thickness = edge * 0.2
        //Normalizing around 0,0
        let verticalBarPath = UIBezierPath(rect: CGRect(x: edge / 2 - thickness, y: -edge / 2, width: thickness, height: edge))

        //Triangle
        let triPath = UIBezierPath()
        
        let shortEdge = edge/2
        triPath.moveToPoint(CGPoint(x: -shortEdge, y: -shortEdge))
        triPath.addLineToPoint(CGPoint(x: shortEdge - thickness, y: 0))
        triPath.addLineToPoint(CGPoint(x: -shortEdge, y: shortEdge))
        triPath.closePath()
        color.setFill()

        let context = UIGraphicsGetCurrentContext()
        if(isPrevious){
            //Flip it!
            CGContextRotateCTM(context, CGFloat(M_PI))

            CGContextTranslateCTM(context, -(inset/2 + edge/2),  -(inset/2 + edge/2))
        } else {
            CGContextTranslateCTM(context, inset/2 + edge/2,  inset/2 + edge/2)
        }
        triPath.fill()
        verticalBarPath.fill()
        
    }


}
