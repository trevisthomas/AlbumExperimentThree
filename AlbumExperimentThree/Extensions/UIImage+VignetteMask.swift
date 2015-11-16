//
//  UIImage+VignetteMask.swift
//  AlbumExperimentThree
//
//  Created by Trevis Thomas on 11/15/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//

import Foundation
import UIKit


extension UIImage {
    
    static func generateAlbumCoverVignette(rect:CGRect) -> UIImage{
        
        UIGraphicsBeginImageContextWithOptions(rect.size, true, UIScreen.mainScreen().scale)
        UIColor.whiteColor().setFill()
        UIRectFill(rect)

        
        //Gradient
        let startColor = UIColor.blackColor()
        let endColor = UIColor.whiteColor()

        
        let context = UIGraphicsGetCurrentContext()
        let colors = [startColor.CGColor, endColor.CGColor]
        
        //3 - set up the color space
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        //4 - set up the color stops
        let colorLocations:[CGFloat] = [0.4, 1.0]
        
        //5 - create the gradient
        let gradient = CGGradientCreateWithColors(colorSpace,
            colors,
            colorLocations)
        
        //6 - draw the gradient
        let startPoint = CGPoint.zero
        let endPoint = CGPoint(x:0, y:rect.height)
        
        CGContextDrawLinearGradient(context,
            gradient,
            startPoint,
            endPoint,
            CGGradientDrawingOptions(rawValue: 0))
//        I played with a radial gradient, but the linear looks beter to me now.
//        let center = CGPoint(x: rect.width / 2, y: rect.height * 0.15)
//        let radius = rect.width * 0.5
//        CGContextDrawRadialGradient(context, gradient, center, 0.0, center, radius, CGGradientDrawingOptions(rawValue: 0))

        //
        
        
        let mask = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return mask
    }
    
//    private static func createImageWithColor(color: UIColor, size: CGSize) -> UIImage {
//        let rect = CGRectMake(0, 0, size.width, size.height)
//        UIGraphicsBeginImageContextWithOptions(size, false, 0)
//        color.setFill()
//        UIRectFill(rect)
//        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return image
//    }

}