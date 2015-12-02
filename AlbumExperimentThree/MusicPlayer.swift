//
//  MusicPlayer.swift
//  AlbumExperimentThree
//
//  Created by Trevis Thomas on 12/1/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//

import Foundation
import MediaPlayer
import AVFoundation

class MusicPlayer {
    static let MusicPlayerNowPlayingItemDidChange = "MusicPlayerNowPlayingItemDidChange"
    static let MusicPlayerStateDidChange = "MusicPlayerStateDidChange"
    static let MusicPlayerTimeUpdate = "MusicPlayerTimeUpdate"
    
    static let TIME_ELAPSED_KEY = "elapsed"
    static let MEDIA_ITEM_KEY = "mediaItem"
    
    static let instance = MusicPlayer()
    
    private var timeObserver : AnyObject?
    
    private static let DEFAULT_INDEX : Int = -1
    
    var mediaItemQueue : [MPMediaItem] = []
    var nowPlayingQueueIndex : Int = DEFAULT_INDEX {
        didSet{
            notifyNowPlayingDidChange() //Too clever?
        }
    }
    
    let nowPlayingInfoCenter = MPNowPlayingInfoCenter.defaultCenter()
    
//    enum MusicPlayerState{
//        case PLAYING
//        case STOPPED //Is this possible?
//        case PAUSED
//    }
    
    private let avPlayer : AVQueuePlayer = AVQueuePlayer()
    
    init() {
        
        avPlayer.actionAtItemEnd = .Advance //Not sure if this is needed
        
        timeObserver = avPlayer.addPeriodicTimeObserverForInterval(CMTimeMake(1, 2), queue: dispatch_get_main_queue(), usingBlock: { (time: CMTime) -> Void in
            let seconds : Double = Float64(time.value) / Float64(time.timescale)
            
            let dict = [MusicPlayer.TIME_ELAPSED_KEY : seconds,
                        MusicPlayer.MEDIA_ITEM_KEY : self.mediaItemQueue[self.nowPlayingQueueIndex]]
            

            NSNotificationCenter.defaultCenter().postNotificationName(MusicPlayer.MusicPlayerTimeUpdate, object: self, userInfo: dict)
            
        })
    }
    
    func play() {
        avPlayer.play()
        
        notifyStateDidChange()
    }
    
    func pause() {
        avPlayer.pause()
        
        notifyStateDidChange()
    }
    
    private func notifyStateDidChange(){
        let dict = [MusicPlayer.MEDIA_ITEM_KEY : self.mediaItemQueue[self.nowPlayingQueueIndex]]
        NSNotificationCenter.defaultCenter().postNotificationName(MusicPlayer.MusicPlayerStateDidChange, object: self, userInfo: dict)
    }
    
    func isPlaying() -> Bool{
        return avPlayer.rate != Float(0.0)
    }
    
    func skipToNextItem(){
        avPlayer.advanceToNextItem()
        
        updateNowPlayingIndex()
    }
    
    func skipToPreviousItem(){
        //avPlayer?.
        
//        http://stackoverflow.com/questions/12176699/skip-to-previous-avplayeritem-on-avqueueplayer-play-selected-item-from-queue
//        - (void)playAtIndex:(NSInteger)index
//        {
//            [player removeAllItems];
//            for (int i = index; i <playerItems.count; i ++) {
//                AVPlayerItem* obj = [playerItems objectAtIndex:i];
//                if ([player canInsertItem:obj afterItem:nil]) {
//                    [obj seekToTime:kCMTimeZero];
//                    [player insertItem:obj afterItem:nil];
//                }
//            }
//        }
    }
    
    func queue(mediaItems: [MPMediaItem]){
        //Load the local queue
        mediaItemQueue.removeAll()
        mediaItemQueue.appendContentsOf(mediaItems)
        
        //Play the queue
        avPlayer.removeAllItems()
        for avItem in mediaItems.asAVPlayerItems(self, selector: "onItemDidFinishPlaying:") {
            avPlayer.insertItem(avItem, afterItem: nil)
        }
        
        //Init the index at zero
        nowPlayingQueueIndex = 0
        
        //TODO! Move this to NowPlayingViewController. That is where the remote control featues are.
        //For the sleep screen.
        loadNowPlayingInfoCenter()
        
        
        //Start the AVPlayer
        play()
    }
    
    private func nowPlayingMediaItem() -> MPMediaItem? {
        if nowPlayingQueueIndex == MusicPlayer.DEFAULT_INDEX {
            return nil
        } else {
           return self.mediaItemQueue[self.nowPlayingQueueIndex]
        }
    }
    
    //This method actually just checks if this album contains the current queued song, it could be paused!!
    func isMyAlbumPlaying(albumId : NSNumber) -> Bool{
        let nowPlayingItem = nowPlayingMediaItem()
        
        if let nowPlayingAlbumId = nowPlayingItem?.valueForProperty(MPMediaItemPropertyAlbumPersistentID) as? NSNumber{
            if albumId == nowPlayingAlbumId {
                return true
            }
        }
        return false
    }
    
    //**************
    //TODO! Move this to NowPlayingViewController. That is where the remote control featues are.  
    //!!!!!!!!!!!!!!
    private func loadNowPlayingInfoCenter(){
        nowPlayingInfoCenter.nowPlayingInfo = [
            MPMediaItemPropertyTitle:mediaItemQueue[nowPlayingQueueIndex].valueForProperty(MPMediaItemPropertyTitle)!,
            MPMediaItemPropertyArtist:"\(mediaItemQueue[nowPlayingQueueIndex].valueForProperty(MPMediaItemPropertyAlbumArtist)!)-\(mediaItemQueue[nowPlayingQueueIndex].valueForProperty(MPMediaItemPropertyAlbumTitle)!)",
            MPMediaItemPropertyArtwork:mediaItemQueue[nowPlayingQueueIndex].valueForProperty(MPMediaItemPropertyArtwork)!,
            MPMediaItemPropertyPlaybackDuration:mediaItemQueue[nowPlayingQueueIndex].valueForProperty(MPMediaItemPropertyPlaybackDuration)!
        ]
    }
    
    //Note! The annotation was required because this class doesnt extend NSObject!!
    @objc func onItemDidFinishPlaying(notification: NSNotification){
        updateNowPlayingIndex()
    }
    
    private func updateNowPlayingIndex(){
        if nowPlayingQueueIndex++ >= mediaItemQueue.count {
            nowPlayingQueueIndex = MusicPlayer.DEFAULT_INDEX
        }
        
        loadNowPlayingInfoCenter() //TODO: this will fail at -1 index
    }
    
    private func notifyNowPlayingDidChange(){
        print("Nofity debug now playing index: \(nowPlayingQueueIndex)")
        
        if nowPlayingQueueIndex == MusicPlayer.DEFAULT_INDEX {
            NSNotificationCenter.defaultCenter().postNotificationName(MusicPlayer.MusicPlayerNowPlayingItemDidChange, object: self)
        } else {
            let dict = [MusicPlayer.MEDIA_ITEM_KEY : self.mediaItemQueue[self.nowPlayingQueueIndex]]
            NSNotificationCenter.defaultCenter().postNotificationName(MusicPlayer.MusicPlayerNowPlayingItemDidChange, object: self, userInfo: dict)
        }

    }
    
}

extension Array {
    func asAVPlayerItems (observer: AnyObject, selector: Selector) -> [AVPlayerItem] {
        var avItems : [AVPlayerItem] = []
        for song in self{
            let avItem = AVPlayerItem(URL: (song as! MPMediaItem).valueForProperty(MPMediaItemPropertyAssetURL) as! NSURL)

            avItem.installDidFinishNotification(observer, selector: selector)
            avItems.append(avItem)
        }
        return avItems
    }
}

extension AVPlayerItem {
    func installDidFinishNotification(observer: AnyObject, selector: Selector){
        NSNotificationCenter.defaultCenter().addObserver(observer, selector: selector, name: AVPlayerItemDidPlayToEndTimeNotification, object: self)
    }
}

extension NSNotification {
    func isNotificationForMyAlbum(albumId : NSNumber) ->Bool{
        let dict = self.userInfo!
        let nowPlayingItem = dict[MusicPlayer.MEDIA_ITEM_KEY]
        
        if let nowPlayingAlbumId = nowPlayingItem?.valueForProperty(MPMediaItemPropertyAlbumPersistentID) as? NSNumber{
            if albumId == nowPlayingAlbumId {
                return true
            }
        }
        return false
    }
}