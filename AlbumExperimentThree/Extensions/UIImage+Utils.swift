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
    
   
    static func collageImage (rect:CGRect, maxImagesPerRow: Int, images:[UIImage]) -> UIImage {
        //Create the mask
        let mask = createImageMaskForImages(rect, maxImagesPerRow : maxImagesPerRow, imageCount: images.count)

        UIGraphicsEndImageContext();
        
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
        
        //Apply the mask Mask
        let maskedImage = applyImageMaskToImage(rect, mask: mask, sourceImage: outputImage)
        
        return maskedImage
    }
    
    private static func applyImageMaskToImage(rect : CGRect, mask : UIImage, sourceImage : UIImage) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.mainScreen().scale)
        CGContextClipToMask(UIGraphicsGetCurrentContext(), rect, mask.CGImage)
        sourceImage.drawAtPoint(CGPointZero)
        
        let maskedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return maskedImage
    }
    
    //This method creates a UIImage that has black arround the edges and white where the images should go.  It's a clipping mask for the grid of images
    private static func createImageMaskForImages(rect:CGRect, maxImagesPerRow: Int, imageCount count: Int) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(rect.size, true, UIScreen.mainScreen().scale)
        UIColor.blackColor().setFill()
        UIRectFill(rect)
        UIColor.whiteColor().setFill()
//        UIColor.grayColor().setFill()  //Playing with alpha on the masked image
        let paths = createPathsForClipping(rect, maxImagesPerRow: maxImagesPerRow, imageCount: count);
        for path in paths {
            path.fill()
        }
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    //This method creates a list of paths that represent the beveled outline for the images that i want to show
    private static func createPathsForClipping(rect:CGRect, maxImagesPerRow: Int, imageCount count: Int) -> [UIBezierPath] {
        var paths : [UIBezierPath] = []
        var maxSide : CGFloat = 0.0
        
        if count >= maxImagesPerRow {
            maxSide = max(rect.width / CGFloat(maxImagesPerRow), rect.height / CGFloat(maxImagesPerRow))
        } else {
            maxSide = max(rect.width / CGFloat(count), rect.height / CGFloat(count))
        }
        
        var index = 0
        var currentRow = 1
        var xtransform:CGFloat = 0.0
        var ytransform:CGFloat = 0.0
        var smallRect:CGRect = CGRectZero
        
        
        for _ in 0...count {
            
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
            
            let p = UIBezierPath(roundedRect: CGRectInset(smallRect, 2, 2), cornerRadius: smallRect.height / 8)
            
            paths.append(p)
        }
        return paths
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
    
}