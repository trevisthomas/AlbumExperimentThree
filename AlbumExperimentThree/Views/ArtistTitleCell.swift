//
//  ArtistTitleCell.swift
//  Album Experiment
//
//  Created by Trevis Thomas on 10/17/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//

import UIKit

class ArtistTitleCell: UICollectionViewCell {
    @IBOutlet weak var artistNameLabel: UILabel!
    var artistName : String!{
        didSet{
            artistNameLabel.text = artistName
        }
    }
//    func adjustSize (relativeTo : CGSize){
////        CGSize current =
////        self.contentView.frame.size.width = relativeTo.width
//        
//        var newSize = self.contentView.frame.size
//        newSize.width = relativeTo.width
//        
//        var newContentFrame = contentView.frame
//        newContentFrame.size = newSize
//        
//        contentView.frame = newContentFrame
//    }
    
}
