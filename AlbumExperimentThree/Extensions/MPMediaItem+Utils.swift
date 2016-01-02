//
//  MPMediaItem+Utils.swift
//  AlbumExperimentThree
//
//  Created by Trevis Thomas on 12/3/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//

import Foundation
import MediaPlayer

extension MPMediaItem {
    func getPersistenceId () -> NSNumber{
        return self.valueForKey(MPMediaItemPropertyPersistentID) as! NSNumber
    }
    
    func getAlbumId () -> NSNumber{
        return self.valueForProperty(MPMediaItemPropertyAlbumPersistentID) as! NSNumber
    }
    
    //Trevis! These are about useless.  The attributes are exposed on this class already.
    
    func getTitle() -> String?{
        return self.valueForProperty(MPMediaItemPropertyTitle) as? String
    }
    
    func getAlbumTitle() -> String?{
        return self.valueForProperty(MPMediaItemPropertyAlbumTitle) as? String
    }
    
    func getAlbumArtist() -> String? {
        return self.valueForProperty(MPMediaItemPropertyArtist) as? String
    }
}