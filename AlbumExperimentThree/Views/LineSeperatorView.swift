//
//  LineSeperatorView.swift
//  AlbumExperimentThree
//
//  Created by Trevis Thomas on 11/4/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//

import UIKit

@IBDesignable

class LineSeperatorView: UIView {
    @IBInspectable var lineColor : UIColor = UIColor.whiteColor()
    @IBInspectable var startInset : CGFloat = 5
    @IBInspectable var endInset : CGFloat = 5
    @IBInspectable var strokeThickness : CGFloat = 0.5
    @IBInspectable var topBottomInset : CGFloat = 5.0
    @IBInspectable var topEdge : Bool = false
    

    override func drawRect(rect: CGRect) {
        if startInset + endInset >= rect.width {
            return
        }
        
        var y : CGFloat!
        
        if topEdge {
            y = topBottomInset
        } else {
            y = rect.height - topBottomInset - strokeThickness
        }
        
        let linePath = UIBezierPath(rect: CGRect(x: startInset, y: y, width: rect.width - startInset - endInset, height: strokeThickness))
        lineColor.setFill()
        linePath.fill()
    }
    

}
