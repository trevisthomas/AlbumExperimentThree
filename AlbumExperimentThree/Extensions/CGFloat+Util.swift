//
//  CGFloat+Util.swift
//  AlbumExperimentThree
//
//  Created by Trevis Thomas on 10/31/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//

import Foundation

extension CGFloat {
    
    // This function takes a 'delta' that is between 0 and 1 and calculates an 'alpha' between minAlpha and maxAlpha
    mutating func scaleYourself(withDelta delta: CGFloat, minAlpha : CGFloat, maxAlpha : CGFloat){
        self = maxAlpha - (delta * (maxAlpha - minAlpha))
    }
}