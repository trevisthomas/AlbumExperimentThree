//
//  SongTableViewCell.swift
//  AlbumExperimentThree
//
//  Created by Trevis Thomas on 11/22/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//

import UIKit

class SongTableViewCell: UITableViewCell {
    
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var trackTitle: UILabel!
    @IBOutlet weak var trackNumber: UILabel!
    var albumData : AlbumData!{
        didSet{
            duration.textColor = albumData.colorPalette.primaryTextColor
            trackTitle.textColor = albumData.colorPalette.primaryTextColor
            trackNumber.textColor = albumData.colorPalette.primaryTextColor
            
        }
    }
    
    var songData : SongData!{
        didSet{
            duration.text = songData.duration
            trackTitle.text = songData.title
            trackNumber.text = String(songData.trackNumber)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
