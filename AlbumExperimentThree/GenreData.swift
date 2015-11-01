//
//  DataBundle.swift
//  Album Experiment
//
//  Created by Trevis Thomas on 10/11/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//

import Foundation
import MediaPlayer

class GenreData {
    
    enum DataType{
        case ALBUM
        case ARTIST
        //TODO add genre podcast
    }
    var title : String = ""
    var detail : String = ""
//    var artwork : String? 
    var isPodcast : Bool = false
    var art : MPMediaItemArtwork!
    var artwork : UIImage! {
        didSet{
            //Using an extension on UI Image to create and cache the colors in the image
            colorsInArtwork = artwork.extractColorsUsingColorCube(numberOfColorsToExtract: 4)
        }
    }
    var colorsInArtwork : [UIColor]!
    
}