//
//  Array+Utils.swift
//  AlbumExperimentThree
//
//  Created by Trevis Thomas on 10/29/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//

import Foundation

extension Array{
    var shuffle:[Element] {
        var elements = self
        for index in 0..<elements.count {
            let anotherIndex = Int(arc4random_uniform(UInt32(elements.count-index)))+index
            if anotherIndex != index {
                swap(&elements[index], &elements[anotherIndex])
            }
        }
        return elements
    }
    
    //Trevis: This might be old and busted.  See indexOf on array, added with Swift 2
    func find(includedElement: Element -> Bool) -> Int? {
        for (idx, element) in enumerate() {
            if includedElement(element) {
                return idx
            }
        }
        return nil
    }
  
}