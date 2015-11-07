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
    @IBInspectable var bottomInset : CGFloat = 5.0
    

    override func drawRect(rect: CGRect) {
        if startInset + endInset >= rect.width {
            return
        }

        let linePath = UIBezierPath(rect: CGRect(x: startInset, y: rect.height - bottomInset - strokeThickness, width: rect.width - startInset - endInset, height: strokeThickness))
        lineColor.setFill()
        linePath.fill()
    }
    

}
