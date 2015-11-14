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
    
    //This method will scale a CGFloat value which is assumed to be between 0 and 1 so that it increases exponentially
    func exponentialDelta() -> CGFloat {
        //The assumption is that 'value' is a number between 0 and
        let scallingFactor : CGFloat = 100
        let exponent : CGFloat = 2.0
        let scaledX = scallingFactor * self //Now i have a number between 0 and 100
        let tempY = pow (scaledX, exponent) //Now i have a number between 0 and 10000
        let exponentialY = tempY / pow (scallingFactor, exponent)
        return exponentialY
    }
}