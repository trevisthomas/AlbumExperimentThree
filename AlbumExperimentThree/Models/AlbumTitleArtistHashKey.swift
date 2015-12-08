//
//  AlbumTitleArtistHashKey.swift
//  AlbumExperimentThree
//
//  Created by Trevis Thomas on 12/8/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//

import Foundation

class AlbumTitleArtistHashKey : Hashable{
    var artistName : String
    var albumTitle : String
    
    init(artistName : String, albumTitle : String){
        self.artistName = artistName
        self.albumTitle = albumTitle
    }
    
    var hashValue: Int {
        return artistName.hashValue ^ albumTitle.hashValue
    }
}

func ==(lhs: AlbumTitleArtistHashKey, rhs: AlbumTitleArtistHashKey) -> Bool {
    return lhs.albumTitle == rhs.albumTitle && lhs.artistName == rhs.artistName
}
