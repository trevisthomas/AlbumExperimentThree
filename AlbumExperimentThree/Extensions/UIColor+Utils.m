//
//  UIColor+Utils.m
//  AlbumExperimentThree
//
//  Created by Trevis Thomas on 11/20/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//
// http://stackoverflow.com/questions/11598043/get-slightly-lighter-and-darker-color-from-uicolor

#import "UIColor+Utils.h"

@implementation UIColor (Utils)

//    - (UIColor *)lighterColorRemoveSaturation:(CGFloat)removeS
//                                  resultAlpha:(CGFloat)alpha {
//        CGFloat h,s,b,a;
//        if ([self getHue:&h saturation:&s brightness:&b alpha:&a]) {
//            return [UIColor colorWithHue:h
//                              saturation:MAX(s - removeS, 0.0)
//                              brightness:b
//                                   alpha:alpha == -1? a:alpha];
//        }
//        return nil;
//    }
//
//    - (UIColor *)lighterColor {
//        return [self lighterColorRemoveSaturation:0.5
//                                      resultAlpha:-1];
//    }

    - (UIColor *)lighterColor
    {
        CGFloat h, s, b, a;
        if ([self getHue:&h saturation:&s brightness:&b alpha:&a])
            return [UIColor colorWithHue:h
                              saturation:s
                              brightness:MIN(b * 1.3, 1.0)
                                   alpha:a];
        return nil;
    }

    - (UIColor *)darkerColor
    {
        CGFloat h, s, b, a;
        if ([self getHue:&h saturation:&s brightness:&b alpha:&a])
            return [UIColor colorWithHue:h
                              saturation:s
                              brightness:b * 0.75
                                   alpha:a];
        return nil;
    }

@end
