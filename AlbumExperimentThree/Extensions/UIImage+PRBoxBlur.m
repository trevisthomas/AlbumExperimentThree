//
//  UIImage+PRBoxBlur.m
//  AlbumExperimentThree
//
//  Created by Trevis Thomas on 11/10/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
// Downloaded from here: http://blog.projectrhinestone.org/high-performance-ios-box-blur-with-accelerate-framework/
//

#import "UIImage+PRBoxBlur.h"
#import <Accelerate/Accelerate.h>

@implementation UIImage (PRBoxBlur)

- (UIImage *)pr_boxBlurredImageWithRadius:(CGFloat)radius
{
    radius *= [UIScreen mainScreen].scale;
    radius = (NSUInteger)floor(radius * 3.f * sqrt(2.f * M_PI) / 4.f + .5f);
    radius *= .5f;
    if (!((NSUInteger)radius % 2)) {
        radius++;
    }
    
    CGImageRef inImageRef = self.CGImage;
    
    size_t width = CGImageGetWidth(inImageRef) * .5f;
    size_t height = CGImageGetHeight(inImageRef) * .5f;
    size_t rowBytes = CGImageGetBytesPerRow(inImageRef) * .5f;
    
    uint32_t *bitmapData = malloc(rowBytes * height);
    CGContextRef inContext = CGBitmapContextCreate(bitmapData,
                                                   width,
                                                   height,
                                                   8,
                                                   rowBytes,
                                                   CGImageGetColorSpace(inImageRef),
                                                   (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(inContext, CGRectMake(0, 0, width, height), inImageRef);
    
    vImage_Buffer inBuffer;
    inBuffer.width = CGBitmapContextGetWidth(inContext);
    inBuffer.height = CGBitmapContextGetHeight(inContext);
    inBuffer.rowBytes = CGBitmapContextGetBytesPerRow(inContext);
    inBuffer.data = CGBitmapContextGetData(inContext);
    
    void *pixelBuffer = malloc(rowBytes * height);
    vImage_Buffer outBuffer;
    outBuffer.width = width;
    outBuffer.height = height;
    outBuffer.rowBytes = rowBytes;
    outBuffer.data = pixelBuffer;
    
    vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, radius, radius, NULL, kvImageEdgeExtend);
    vImageBoxConvolve_ARGB8888(&outBuffer, &inBuffer, NULL, 0, 0, radius, radius, NULL, kvImageEdgeExtend);
    vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, radius, radius, NULL, kvImageEdgeExtend);
    
    CGContextRef outContext = CGBitmapContextCreate(outBuffer.data,
                                                    outBuffer.width,
                                                    outBuffer.height,
                                                    8,
                                                    outBuffer.rowBytes,
                                                    CGImageGetColorSpace(inImageRef),
                                                    (CGBitmapInfo)kCGImageAlphaNoneSkipLast);
    CGImageRef outImageRef = CGBitmapContextCreateImage(outContext);
    UIImage *outImage = [UIImage imageWithCGImage:outImageRef];
    
    CFRelease(outImageRef);
    CGContextRelease(outContext);
    free(pixelBuffer);
    free(bitmapData);
    CGContextRelease(inContext);
    
    return outImage;
}

@end