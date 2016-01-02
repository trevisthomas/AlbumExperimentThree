//
//  SongHistoryTableViewCell.swift
//  AlbumExperimentThree
//
//  Created by Trevis Thomas on 1/1/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit
import MediaPlayer

class SongHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var albumArt: UIImageView!
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var songDetailLabel: UILabel!
    
    
//    var songId : NSNumber! {
//        didSet {
////            albumData = MusicLibrary.instance.queryAlbumByPersistenceID(albumId)
//            
//            songData = MusicLibrary.instance.querySongWithPersistenceID(songId)
//            
//            songTitleLabel.text = songData.title
////            songDetailLabel.text = ("\(albumData.artist)")
//            
//            songDetailLabel.text = "todo"
//            
//        }
//    }
//    
//    
//    
//    private var songData : SongData!
    
    var mediaItem : MPMediaItem! {
        didSet{
            songTitleLabel.text = mediaItem?.getTitle()
            songDetailLabel.text = "\(mediaItem!.albumArtist!) - \(mediaItem!.albumTitle!)"
            albumArt.image = mediaItem.artwork?.imageWithSize(albumArt.bounds.size)
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
