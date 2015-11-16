//
//  UIImage+Mask.m
//  AlbumExperimentThree
//
//  Created by Trevis Thomas on 11/15/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//

#import "UIImage+Mask.h"
#import <Foundation/Foundation.h>

@implementation UIImage (Mask)

//Masking came from : http://stackoverflow.com/questions/5757386/how-to-mask-an-uiimageview

//- (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage {
- (UIImage*) maskImageWithMask: (UIImage *)maskImage {

    CGImageRef maskRef = maskImage.CGImage;
    
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageRef maskedImageRef = CGImageCreateWithMask([self CGImage], mask);
    UIImage *maskedImage = [UIImage imageWithCGImage:maskedImageRef];
    
    CGImageRelease(mask);
    CGImageRelease(maskedImageRef);
    
    // returns new image with mask applied
    return maskedImage;
}

@end