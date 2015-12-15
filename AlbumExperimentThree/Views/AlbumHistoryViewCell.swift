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
    @IBOutlet weak var playPauseButton: OverlayPlayPauseButton!
//    private var currentTimer : NSTimer!
    
    
    var albumData : AlbumData! {
        didSet{
            albumTitleLabel.text = albumData.title
            artistNameLabel.text = albumData.artist
            artworkImageView.image = albumData.albumArtWithSize(artworkImageView.bounds.size)
            outerBoxView.backgroundColor = albumData.colorPalette.backgroundColor.lighterColor()
            albumTitleLabel.textColor = albumData.colorPalette.primaryTextColor
            artistNameLabel.textColor = albumData.colorPalette.primaryTextColor
            
            playPauseButton.progressPercentage = 0
            
            //Scrolling the cells off of the screen was clearing their state.  Below is a fix for that
            if MusicPlayer.instance.isMyAlbumPlaying(albumData.albumId){
                playPauseButton.isPlaying = MusicPlayer.instance.isPlaying()
            } else {
                playPauseButton.isPlaying = false
            }
        }
    }
    
    @IBAction func playPauseAction(sender: OverlayPlayPauseButton) {
        if MusicPlayer.instance.isMyAlbumPlaying(albumData.albumId) {
            if MusicPlayer.instance.isPlaying(){
                MusicPlayer.instance.pause()
            } else {
                MusicPlayer.instance.play()
            }
        } else {
            MusicLibrary.instance.playAlbum(albumData.albumId)
        }
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        registerForMusicPlayerNotifications()
    }
    
    func registerForMusicPlayerNotifications(){
        let nc = NSNotificationCenter.defaultCenter()
        
        //Last param is optional
        nc.addObserver(self, selector: "onMusicPlayerNowPlayingDidChange:", name: MusicPlayer.MusicPlayerNowPlayingItemDidChange, object: MusicPlayer.instance)
        nc.addObserver(self, selector: "onMusicPlayerStateChange:", name: MusicPlayer.MusicPlayerStateDidChange, object: MusicPlayer.instance)
        nc.addObserver(self, selector: "onTimeElapsed:", name: MusicPlayer.MusicPlayerTimeUpdate, object: MusicPlayer.instance)
        
    }
    
    func onMusicPlayerNowPlayingDidChange(notification: NSNotification){
        if notification.isNotificationForMyAlbum(albumData.albumId) && MusicPlayer.instance.isPlaying(){
            playPauseButton.isPlaying = true
        } else {
            playPauseButton.isPlaying = false
            playPauseButton.progressPercentage = 0
        }
    }
    
    func onMusicPlayerStateChange(notification: NSNotification){
        if notification.isNotificationForMyAlbum(albumData.albumId){
            playPauseButton.isPlaying = MusicPlayer.instance.isPlaying()
        } else {
            playPauseButton.isPlaying = false
        }
    }
    
    func onTimeElapsed(notification: NSNotification){
        if notification.isNotificationForMyAlbum(albumData.albumId){
            let dict = notification.userInfo!
            let currentPlaybackTime = dict[MusicPlayer.TIME_ELAPSED_KEY] as! Double
            let nowPlayingItem = dict[MusicPlayer.MEDIA_ITEM_KEY]

            let duration = nowPlayingItem?.valueForProperty(MPMediaItemPropertyPlaybackDuration) as! Double
            
            let percentageProgress = CGFloat(currentPlaybackTime / duration)
            
            playPauseButton.progressPercentage = percentageProgress
            
//            print("\(percentageProgress * 100)  \(String.convertSecondsToHHMMSS(currentPlaybackTime))")
        }
        
    }
    
}


