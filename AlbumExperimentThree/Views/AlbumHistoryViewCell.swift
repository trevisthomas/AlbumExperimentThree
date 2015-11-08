//
//  AlbumHistoryViewCell.swift
//  AlbumExperimentThree
//
//  Created by Trevis Thomas on 10/29/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//

import UIKit

class AlbumHistoryViewCell: UICollectionViewCell {
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var albumTitleLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    
    var albumData : AlbumData! {
        didSet{
            albumTitleLabel.text = albumData.title
            artistNameLabel.text = albumData.artist
            
            if albumData.art == nil {
                artworkImageView.image = UIImage(named: "album-placeholder")
            } else {
                artworkImageView.image = albumData.art.imageWithSize(artworkImageView.bounds.size)
            }
            
        }
    }
    
    
}