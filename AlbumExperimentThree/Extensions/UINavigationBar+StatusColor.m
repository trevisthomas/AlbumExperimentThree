//
//  UINavigationBar+StatusColor.m
//  AlbumExperimentThree
//
//  Created by Trevis Thomas on 11/19/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//
// http://stackoverflow.com/questions/23383508/ios7-is-it-possible-to-change-status-bar-color

#import "UINavigationBar+StatusColor.h"

@implementation UINavigationBar (StatusColor)
    /// sets the status bar text color. returns YES on success.
    /// currently, this only
    /// works in iOS 7. It uses undocumented, inofficial APIs.
   - (BOOL) setStatusBarColor:(UIColor*) color;
    {
        id statusBarWindow = [[UIApplication sharedApplication] valueForKey:@"statusBarWindow"];
        id statusBar = [statusBarWindow valueForKey:@"statusBar"];
        
        SEL setForegroundColor_sel = NSSelectorFromString(@"setForegroundColor:");
        if([statusBar respondsToSelector:setForegroundColor_sel]) {
            // iOS 7+
            [statusBar performSelector:setForegroundColor_sel withObject:color];
            return YES;
        } else {
            return NO;
        }
    }
@end
