//
//  ImageColorPalette.swift
//  AlbumExperimentThree
//
//  Created by Trevis Thomas on 11/15/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//
//  Just a little helper wrapper class around arround the UIImage+Color category
//

import Foundation

class ImageColorPalette {
    let backgroundColor : UIColor
    let primaryTextColor : UIColor
    let secondaryTextColor : UIColor
    
    init (fromImage image : UIImage) {
        backgroundColor = image.footerAverageColor()
        primaryTextColor = image.primaryColorFromBackgroundColor(backgroundColor)
        secondaryTextColor = image.secondaryColorFromBackgroundColor(backgroundColor, primaryColor: primaryTextColor)
    }
}