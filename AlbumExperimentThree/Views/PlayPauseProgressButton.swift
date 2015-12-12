//
//  PlayPauseProgressButton.swift
//  AlbumExperimentThree
//
//  Created by Trevis Thomas on 12/11/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//

import UIKit

@IBDesignable

class PlayPauseProgressButton: UIButton {
    
    //New hottness
    @IBInspectable var inset : CGFloat = 1  //Inset of this control within it's bounding box
    @IBInspectable var progressLineWidth : CGFloat = 2
    @IBInspectable var outerCircleLineWidth : CGFloat = 2
    @IBInspectable var outerCircleLineColor : UIColor = UIColor.greenColor()
    @IBInspectable var progressColor : UIColor = UIColor.redColor()
    @IBInspectable var color : UIColor = UIColor.whiteColor()
    
    @IBInspectable var fontSize : CGFloat = 50
    @IBInspectable var timeInTrack : String = "0:00:01"
    
    var innerPadding : CGFloat = 0 //This inner padding is to make the triangle smaller than the inside of the circle.  Be careful chaning this.  If it's smaller than half of the radius bad things will happen
//
//    //Old and busted
//    @IBInspectable var leftInset : CGFloat = 10
//    @IBInspectable var topInset : CGFloat = 10
//    @IBInspectable var radius : CGFloat = 20
////    @IBInspectable var progressLineWidth : CGFloat = 5
//    @IBInspectable var progressPathLineWidth : CGFloat = 1
//
//    @IBInspectable var alphaOfTransparentArea : CGFloat = 0.6
//    
//    @IBInspectable var progressPathColor : UIColor = UIColor.blackColor()
    
    @IBInspectable var progressPercentage : CGFloat = 0.52 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    
    @IBInspectable var isPlaying : Bool = false {
        didSet{
            setNeedsDisplay()
        }
    }
    
    private let π:CGFloat = CGFloat(M_PI)
    
    override func drawRect(rect: CGRect) {
        let boxSize = rect.width > rect.height ? rect.width : rect.height
        let size = boxSize - inset
        
        let context = UIGraphicsGetCurrentContext()
        let center = CGPoint(x: boxSize / 2, y: boxSize / 2)
        
        //Circle
        let outerCirclePath = UIBezierPath(arcCenter: center,
            radius: (size / 2) - outerCircleLineWidth/2 , //- lineWidth/2,
            startAngle: 0,
            endAngle: 2 * π,
            clockwise: true)
        
        outerCirclePath.lineWidth = outerCircleLineWidth
        outerCircleLineColor.setStroke()
        outerCirclePath.stroke()
        
        //Progress
        let startAngle: CGFloat = ((3 * π) / 2)
        let endAngle: CGFloat = ((3 * π) / 2) + ((2 * π) * progressPercentage)
        
        let progressPath = UIBezierPath(arcCenter: center,
            radius: (size / 2) - progressLineWidth/2 , //- lineWidth/2,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true)
        
        progressPath.lineWidth = progressLineWidth
        progressColor.setStroke()
        progressPath.stroke()
        
        //Calculate the edge of the largest square that fits inside of the inner circle
        let innerDiameter = (size - (2 * progressLineWidth)) - innerPadding
        let edge = sqrt((pow(innerDiameter, 2.0)) / 2.0)
        
        if isPlaying {
            let barWidth = size * 0.1
            
//            let leftRectPath = UIBezierPath(rect: CGRect(x: (rect.width / 2) - 2 * barWidth , y: insetInterior, width: barWidth, height: rect.height - (2 * insetInterior)))
//            
//            let rightRectPath = UIBezierPath(rect: CGRect(x: (rect.width / 2) + barWidth, y: insetInterior, width: barWidth, height: rect.height - (2 * insetInterior)))
            
            
            
            let leftRectPath = UIBezierPath(rect: CGRect(x: (rect.width / 2) - 2 * barWidth , y: (rect.height - edge) / 2, width: barWidth, height: edge))
            
            let rightRectPath = UIBezierPath(rect: CGRect(x: (rect.width / 2) + barWidth, y: (rect.height - edge) / 2, width: barWidth, height: edge))
            
            color.setFill()
            leftRectPath.fill()
            rightRectPath.fill()
        } else {
            CGContextSaveGState(context)
            
            //Triangle
            let triPath = UIBezierPath()
            
            //This nudge is a hack and is covering for bad math.  It results in a triangle that has a slight inset.  To make it fit fully just set your innerPadding to negative.
            let nudge = ((innerDiameter / 2) - (edge/2)) / 2
            
            triPath.moveToPoint(CGPoint(x: -edge/2, y: -edge/2))
            triPath.addLineToPoint(CGPoint(x: edge/2, y: 0)) //Makes the triangle
            triPath.addLineToPoint(CGPoint(x: -edge/2, y: edge/2))
            triPath.closePath()
            color.setFill()
            
            //Move it into position
            CGContextTranslateCTM(context, center.x + nudge, center.y)
            triPath.fill()
            
            CGContextRestoreGState(context)
            CGContextSaveGState(context)
        }
        
        let fieldFont = UIFont(name: "Helvetica Neue", size: fontSize)!
        let textRect = CGRectMake(center.x - edge/2, center.y - (fieldFont.pointSize / 2), edge, fieldFont.pointSize)
        drawText(timeInTrack, rect: textRect, font: fieldFont)
    }
    
    func drawText(text : String, rect : CGRect, font : UIFont){
//        let fontSize = rect.height
        
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = NSLineBreakMode.ByClipping
        paragraphStyle.alignment = NSTextAlignment.Center
        
        let attributes: NSDictionary = [
            NSForegroundColorAttributeName: UIColor.blackColor(),
            NSParagraphStyleAttributeName: paragraphStyle,
            NSFontAttributeName: font,
        ]
        
        let string = text as NSString
        
        
        string.drawInRect(rect, withAttributes: attributes as? [String : AnyObject])
        
        
//        [s drawInRect: textRect
//            withFont: font
//            lineBreakMode: UILineBreakModeClip
//            alignment: UITextAlignmentCenter];
    }
    
//    func drawRect_(rect: CGRect) {
//        // Drawing code
//        
//        let context = UIGraphicsGetCurrentContext()
//        CGContextSaveGState(context)
//        
////        let lineWidth = radius * 0.1 //Just making the outer circle 10% of the radius
//        
//        let lineWidth = progressLineWidth
//        
//        radius = rect.width * 0.99
//        
//        let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
//        
//        //Normalizing around 0,0
//        let buttonRect = CGRect(x: -(rect.width - lineWidth) / 2, y: -(rect.width - lineWidth) / 2, width: radius, height: radius)
//        //Draw the tinted circle
//        let path = UIBezierPath(ovalInRect: buttonRect)
//        let transparentColor = UIColor(red: 0, green: 0, blue: 0, alpha: alphaOfTransparentArea)
//        transparentColor.setFill()
//        
//        
//        //Outer circle
//        path.lineWidth = lineWidth
//        color.setStroke()
//        
//        
//        //Move to position and draw the circle
//        CGContextTranslateCTM(context, leftInset + ((radius+lineWidth)/2), topInset + ((radius+lineWidth)/2))
//        path.fill()
//        path.stroke()
//        
//        //Revert the context
//        CGContextRestoreGState(context)
//        //Save the context again so that it is restorable
//        CGContextSaveGState(context)
//        
//        //Progress arc
////        let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
//        
//        let startAngle: CGFloat = ((3 * π) / 2)
//        let endAngle: CGFloat = ((3 * π) / 2) + ((2 * π) * progressPercentage)
//        
//        let progressPath = UIBezierPath(arcCenter: center,
//            radius: radius/2, //- lineWidth/2,
//            startAngle: startAngle,
//            endAngle: endAngle,
//            clockwise: true)
//        
//        progressPath.lineWidth = lineWidth
//        progressColor.setStroke()
//        progressPath.stroke()
//        
//        
//        if isPlaying {
//            let barWidth = lineWidth
//            let insetInterior = topInset + 0.25 * radius
//            
//            let leftRectPath = UIBezierPath(rect: CGRect(x: (rect.width / 2) - 2 * barWidth , y: insetInterior, width: barWidth, height: rect.height - (2 * insetInterior)))
//            
//            let rightRectPath = UIBezierPath(rect: CGRect(x: (rect.width / 2) + barWidth, y: insetInterior, width: barWidth, height: rect.height - (2 * insetInterior)))
//            
//            color.setFill()
//            leftRectPath.fill()
//            rightRectPath.fill()
//            
//        } else {
//            //Triangle
//            let triPath = UIBezierPath()
//            //Calculate the edge of the largest square that fits inside of the inner circle
//            let innerRadius = (radius - 2 * lineWidth) - innerPadding
//            let edge = sqrt((pow(innerRadius, 2.0)) / 2.0)
//            triPath.moveToPoint(CGPoint(x: -edge/2, y: -edge/2))
//            triPath.addLineToPoint(CGPoint(x: edge/2, y: 0))
//            triPath.addLineToPoint(CGPoint(x: -edge/2, y: edge/2))
//            triPath.closePath()
//            color.setFill()
//            
//            //Move it into position
//            CGContextTranslateCTM(context, leftInset + ((radius+lineWidth + innerPadding)/2), topInset + ((radius+lineWidth + innerPadding)/2))
//            triPath.fill()
//        }
//        
//        
//        CGContextRestoreGState(context)
//        
//    }
}
