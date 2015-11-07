//
//  MoreArrowView.swift
//  AlbumExperimentThree
//
//  Created by Trevis Thomas on 11/4/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//

import UIKit

@IBDesignable

class MoreArrowView: UIView {
    @IBInspectable var arrowColor : UIColor = UIColor.blackColor()
    @IBInspectable var lefty : Bool = false
    @IBInspectable var arrowHeight : CGFloat = 40
    @IBInspectable var edgeInset : CGFloat = 5
    @IBInspectable var arrowWidth : CGFloat = 20
    @IBInspectable var thickness : CGFloat = 1.5
    
    override func drawRect(rect: CGRect) {
//        if arrowHeight >= rect.height {
//            return
//        }
        
        let linePath = UIBezierPath()
        
        linePath.lineCapStyle = .Butt
        linePath.lineWidth = thickness
        arrowColor.setStroke()
        
        if lefty {
            linePath.moveToPoint(CGPoint (x: edgeInset + arrowWidth, y: rect.height / 2 - arrowHeight / 2))
            linePath.addLineToPoint(CGPoint(x: edgeInset, y: rect.height / 2))
            linePath.addLineToPoint(CGPoint(x: edgeInset + arrowWidth, y: rect.height / 2 + arrowHeight / 2))
        } else {
            linePath.moveToPoint(CGPoint(x: rect.width - edgeInset - arrowWidth, y: rect.height / 2 - arrowHeight / 2))
            linePath.addLineToPoint(CGPoint(x:rect.width - edgeInset, y: rect.height / 2))
            linePath.addLineToPoint(CGPoint(x: rect.width - edgeInset - arrowWidth, y: rect.height / 2 + arrowHeight / 2))
        }
        linePath.stroke()
    }
    

}
