//
//  UIImage+Utils.swift
//  AlbumExperimentThree
//
//  Created by Trevis Thomas on 10/29/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    private static let colorCube = CCColorCube()
   
    
    static func collageImage (rect:CGRect, maxImagesPerRow: Int, images:[UIImage]) -> UIImage {
        
        var maxSide : CGFloat = 0.0
        
        if images.count >= maxImagesPerRow {
            maxSide = max(rect.width / CGFloat(maxImagesPerRow), rect.height / CGFloat(maxImagesPerRow))
        } else {
            maxSide = max(rect.width / CGFloat(images.count), rect.height / CGFloat(images.count))
        }
        
        var index = 0
        var currentRow = 1
        var xtransform:CGFloat = 0.0
        var ytransform:CGFloat = 0.0
        var smallRect:CGRect = CGRectZero
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false,  UIScreen.mainScreen().scale)
        
        for img in images {
            
            let x = ++index % maxImagesPerRow //row should change when modulus is 0
            
            //row changes when modulus of counter returns zero @ maxImagesPerRow
            if x == 0 {
                //last column of current row
                smallRect = CGRectMake(xtransform, ytransform, maxSide, maxSide)
                
                //reset for new row
                ++currentRow
                xtransform = 0.0
                ytransform = (maxSide * CGFloat(currentRow - 1))
                
            } else {
                //not a new row
                smallRect = CGRectMake(xtransform, ytransform, maxSide, maxSide)
                xtransform += CGFloat(maxSide)
            }
            
            //draw in rect
            img.drawInRect(smallRect)
            
        }
        
        let outputImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        return outputImage
    }
    
    static func rotateImage(src: UIImage, radian:CGFloat) -> UIImage
    {
        //  Calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox = UIView(frame: CGRectMake(0,0, src.size.width, src.size.height))
        
        let t: CGAffineTransform  = CGAffineTransformMakeRotation(radian)
        
        rotatedViewBox.transform = t
        let rotatedSize = rotatedViewBox.frame.size
        
        //  Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        
        let bitmap:CGContextRef = UIGraphicsGetCurrentContext()!
        
        //  Move the origin to the middle of the image so we will rotate and scale around the center.
        CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
        
        //  Rotate the image context
        CGContextRotateCTM(bitmap, radian);
        
        //  Now, draw the rotated/scaled image into the context
        CGContextScaleCTM(bitmap, 1.0, -1.0);
        CGContextDrawImage(bitmap, CGRectMake(-src.size.width / 2, -src.size.height / 2, src.size.width, src.size.height), src.CGImage)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func extractColorsUsingColorCube(numberOfColorsToExtract count: UInt) -> [UIColor]{
        var colors = UIImage.colorCube.extractColorsFromImage(self, flags: CCAvoidWhite.rawValue | CCAvoidBlack.rawValue, count: count) as! [UIColor]
        
        if colors.count < Int(count) {
            colors = UIImage.colorCube.extractColorsFromImage(self, flags: CCAvoidBlack.rawValue, count: count) as! [UIColor]
        }
        
        //I noticed that when telling the cube to avoid colors that it could return fewer colors than i was asking for below is a hack around that.  Should probably just call it again without the filters.
        while colors.count < Int(count){
            colors.append(UIColor.whiteColor())
        }
        
        return colors
    }
}