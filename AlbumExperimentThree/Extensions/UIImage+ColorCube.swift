//
//  UIImage+ColorCube.swift
//  AlbumExperimentThree
//
//  Created by Trevis Thomas on 11/4/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//

import Foundation

extension UIImage {

    private static let colorCube = CCColorCube()
    
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
    
    func extractColorsUsingColorCubeSimple(numberOfColorsToExtract count: UInt) -> [UIColor]{
        let colors = UIImage.colorCube.extractColorsFromImage(self, flags: CCAvoidBlack.rawValue, count: count) as! [UIColor]
        return colors
    }
}
