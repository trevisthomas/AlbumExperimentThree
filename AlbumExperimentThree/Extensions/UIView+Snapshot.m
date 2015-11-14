//
//  UIView+Snapshot.m
//  AlbumExperimentThree
//
//  Created by Trevis Thomas on 11/10/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//
// http://stackoverflow.com/questions/22489287/how-do-you-convert-a-uiview-into-a-uiimage-for-adding-to-a-uiimageview

#import <UIKit/UIKit.h>
#import "UIView+Snapshot.h"

@implementation UIView (Snapshot)

- (UIImage *) getSnapshot
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, self.window.screen.scale);
    
    [self drawViewHierarchyInRect:self.frame afterScreenUpdates:YES];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return snapshotImage;
}


@end