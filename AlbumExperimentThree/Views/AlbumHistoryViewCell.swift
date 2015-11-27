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
    private var currentTimer : NSTimer!
    
    let mediaPlayerController = MPMusicPlayerController.systemMusicPlayer()
    
    var albumData : AlbumData! {
        didSet{
            albumTitleLabel.text = albumData.title
            artistNameLabel.text = albumData.artist
            artworkImageView.image = albumData.albumArtWithSize(artworkImageView.bounds.size)
            outerBoxView.backgroundColor = albumData.colorPalette.backgroundColor.lighterColor()
            albumTitleLabel.textColor = albumData.colorPalette.primaryTextColor
            artistNameLabel.textColor = albumData.colorPalette.primaryTextColor
            
            updatePlayState() //Scrolling the cells off of the screen was clearing their state.  This was an attempt to fix that
        }
    }
    
    @IBAction func playPauseAction(sender: OverlayPlayPauseButton) {
        MusicLibrary.instance.playAlbum(albumData.albumId)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        registerMediaPlayerNotifications()
    }
    
    func registerMediaPlayerNotifications() {
//        let mediaPlayerController = MPMusicPlayerController.systemMusicPlayer()
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "handleNowPlaingItemChanged:", name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification, object: mediaPlayerController)
        
        notificationCenter.addObserver(self, selector: "handlePlaybackStateChanged:", name: MPMusicPlayerControllerPlaybackStateDidChangeNotification, object: mediaPlayerController)
        
        notificationCenter.addObserver(self, selector: "handleVolumeChanged:", name: MPMusicPlayerControllerVolumeDidChangeNotification, object: mediaPlayerController)
        
        //Trevis, you may want to unregister at some point?
        mediaPlayerController.beginGeneratingPlaybackNotifications()
    }
    
    
    
    //Trevis, when to call this?
    func unregisterMediaPlayerNotifications(){
        let notificationCenter = NSNotificationCenter.defaultCenter()
        
        let mediaPlayerController = MPMusicPlayerController.systemMusicPlayer()
        mediaPlayerController.endGeneratingPlaybackNotifications()
        notificationCenter.removeObserver(self)
    }
    
    func onTimer( timer : NSTimer) {
        let mediaPlayerController = MPMusicPlayerController.systemMusicPlayer()
        let currentPlaybackTime = mediaPlayerController.currentPlaybackTime
        
        print(String.convertSecondsToHHMMSS(currentPlaybackTime))
        

    }
    
}

extension AlbumHistoryViewCell {
    func handleNowPlaingItemChanged(notification: NSNotification){
//        let mediaPlayerController = MPMusicPlayerController.systemMusicPlayer()
//        let nowPlayingItem = mediaPlayerController.nowPlayingItem
//        
//        //Am I playing!?
//        if let nowPlayingAlbumId = nowPlayingItem?.valueForProperty(MPMediaItemPropertyAlbumPersistentID) as? NSNumber{
//            if albumData.albumId == nowPlayingAlbumId {
//                playPauseButton.isPlaying = true
//            } else {
//                playPauseButton.isPlaying = false
//            }
//        } else {
//            playPauseButton.isPlaying = false
//        }
//        
//        if playPauseButton.isPlaying {
//            //I am playing, set the timer!
//        }
        
        if playPauseButton == nil {
            return
        }
        
        if isMyAlbumPlaying() {
            playPauseButton.isPlaying = true
//            currentTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "onTimer:", userInfo: nil, repeats: true)
        } else {
            playPauseButton.isPlaying = false
//            currentTimer.invalidate()
//            currentTimer = nil
        }

    }
    func handlePlaybackStateChanged(notification: NSNotification){
        updatePlayState()
        

    }
    
    func isMyAlbumPlaying() -> Bool{
        let mediaPlayerController = MPMusicPlayerController.systemMusicPlayer()
        let nowPlayingItem = mediaPlayerController.nowPlayingItem
        
        if let nowPlayingAlbumId = nowPlayingItem?.valueForProperty(MPMediaItemPropertyAlbumPersistentID) as? NSNumber{
            if albumData.albumId == nowPlayingAlbumId {
                return true
            }
        }
        return false
    }
    
    func updatePlayState(){
        if playPauseButton == nil {
            return
        }
        
        if isMyAlbumPlaying() {
            playPauseButton.isPlaying = true
            
            let mediaPlayerController = MPMusicPlayerController.systemMusicPlayer()
            let state = mediaPlayerController.playbackState
            
            switch state {
            case .Playing:
                playPauseButton.isPlaying = true
                
            case .Paused, .Stopped:
                playPauseButton.isPlaying = false
                
            default: break
            }
            
        } else {
            playPauseButton.isPlaying = false
            //destroy the timer
        }
    }
}
