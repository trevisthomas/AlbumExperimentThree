//
//  AdditionalTrackMetaData.swift
//  AlbumExperimentThree
//
//  Created by Trevis Thomas on 12/6/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//

import Foundation

class AdditionalTrackMetaData {
    var dateAdded : NSDate!
    var albumId : NSNumber!
    
    init(dateAdded : NSDate, albumId : NSNumber){
        self.albumId = albumId
        self.dateAdded = dateAdded
    }
    
}