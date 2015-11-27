//
//  AlbumHistoryViewCell.swift
//  AlbumExperimentThree
//
//  Created by Trevis Thomas on 10/29/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//

import UIKit
import MediaPlayer

class AlbumHistoryViewCell: UICollectionViewCell {
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var albumTitleLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var outerBoxView: UIView!
    
    var albumData : AlbumData! {
        didSet{
            albumTitleLabel.text = albumData.title
            artistNameLabel.text = albumData.artist
            artworkImageView.image = albumData.albumArtWithSize(artworkImageView.bounds.size)
            outerBoxView.backgroundColor = albumData.colorPalette.backgroundColor.lighterColor()
            albumTitleLabel.textColor = albumData.colorPalette.primaryTextColor
            artistNameLabel.textColor = albumData.colorPalette.primaryTextColor
        }
    }
    
    @IBAction func playPauseAction(sender: OverlayPlayPauseButton) {
//        let mediaPlayerController = MPMusicPlayerController.systemMusicPlayer()
//        
//        let collection = MusicLibrary.instance.getMediaItemCollectionForAlbum(albumData.albumId)
//        mediaPlayerController.setQueueWithItemCollection(<#T##itemCollection: MPMediaItemCollection##MPMediaItemCollection#>)
        
        MusicLibrary.instance.playAlbum(albumData.albumId)
    }
    
}
