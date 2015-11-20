//
//  UIColor+Utils.h
//  AlbumExperimentThree
//
//  Created by Trevis Thomas on 11/20/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef UIColor_Util_h
#define UIColor_Util_h

@interface UIColor (Utils)
//    - (UIColor *)lighterColorRemoveSaturation:(CGFloat)removeS resultAlpha:(CGFloat)alpha;
    - (UIColor *)darkerColor;
    - (UIColor *)lighterColor;
@end

#endif //UIColor_Util_h