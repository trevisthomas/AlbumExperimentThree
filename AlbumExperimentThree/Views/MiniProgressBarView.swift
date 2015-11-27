//
//  MiniProgressBarView.swift
//  AlbumExperimentThree
//
//  Created by Trevis Thomas on 11/26/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//

import UIKit

class MiniProgressBarView: UIView {

    @IBInspectable var trackColor : UIColor = UIColor.grayColor()
    @IBInspectable var barColor : UIColor = UIColor.blackColor()
    
    
    @IBInspectable var trackHeight : CGFloat = 0.5
    @IBInspectable var barHeight : CGFloat = 1.5
    
    private var position : CGFloat = 0
    var multiplier : CGFloat = 0
    
    var duration : Double! {
        didSet{
            multiplier = CGFloat(frame.width) / CGFloat(duration)
            progress = 0
            setNeedsDisplay()
        }
    }
    var progress : Double! {
        didSet {
            position = multiplier * CGFloat(progress)
            setNeedsDisplay()
        }
    }
    
    
    override func drawRect(rect: CGRect) {
//        if position == nil {
//            return
//        }
        
        let progressPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: position, height: barHeight))
        barColor.setFill()
        progressPath.fill()
        
        let trackPath = UIBezierPath(rect: CGRect(x: position, y: 0, width: rect.width - position, height: trackHeight))
        trackColor.setFill()
        trackPath.fill()
    }
}
