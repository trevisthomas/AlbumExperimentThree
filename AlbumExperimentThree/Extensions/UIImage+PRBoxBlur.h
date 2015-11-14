//
//  UIImage+PRBoxBlur.h
//  AlbumExperimentThree
//
//  Created by Trevis Thomas on 11/10/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//

#ifndef UIImage_PRBoxBlur_h
#define UIImage_PRBoxBlur_h

#import <UIKit/UIKit.h>

@interface UIImage (PRBoxBlur)

- (UIImage *)pr_boxBlurredImageWithRadius:(CGFloat)radius;

@end

#endif /* UIImage_PRBoxBlur_h */
