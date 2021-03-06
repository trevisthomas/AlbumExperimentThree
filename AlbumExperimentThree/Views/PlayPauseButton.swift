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
    @IBInspectable var isPlaying : Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable var color : UIColor = UIColor.orangeColor()
    @IBInspectable var strokeColor : UIColor = UIColor.greenColor()
    @IBInspectable var lineWidth : CGFloat = 0.5
    @IBInspectable var outlineColor : UIColor = UIColor.blackColor()
    @IBInspectable var outlineInset : CGFloat = 2.0
    
    
    override func drawRect(rect: CGRect) {
        let outlinePath = UIBezierPath(roundedRect: CGRect(x: rect.origin.x + outlineInset, y: rect.origin.y + outlineInset, width: rect.width - 2 * outlineInset, height: rect.height - 2 * outlineInset), cornerRadius: rect.height * 0.25)
        
        outlinePath.lineWidth = lineWidth
        outlineColor.setStroke()
        outlinePath.stroke()
        
        
        if isPlaying {
            let barWidth = rect.width * 0.1
            
            let leftRectPath = UIBezierPath(rect: CGRect(x: (rect.width / 2) - 2 * barWidth , y: inset/2, width: barWidth, height: rect.height - inset))
            
            let rightRectPath = UIBezierPath(rect: CGRect(x: (rect.width / 2) + barWidth, y: inset/2, width: barWidth, height: rect.height - inset))

            color.setFill()
            strokeColor.setStroke()
            
            leftRectPath.fill()
            leftRectPath.stroke()
            
            rightRectPath.fill()
            rightRectPath.stroke()
            
        } else {
            //Triangle
            let triPath = UIBezierPath()
            let edge = min(rect.width, rect.height) - inset
            
            triPath.moveToPoint(CGPoint(x: -edge/2, y: -edge/2))
            triPath.addLineToPoint(CGPoint(x: edge/2, y: 0))
            triPath.addLineToPoint(CGPoint(x: -edge/2, y: edge/2))
            triPath.closePath()
            
            color.setFill()
            strokeColor.setStroke()
            
            CGContextTranslateCTM(UIGraphicsGetCurrentContext(), inset/2 + edge/2,  inset/2 + edge/2)
            triPath.fill()
            triPath.stroke()
        }
        
        
    }
    
   
}
