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
    
    var mediaItemNow : MPMediaItem? = nil
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
        var dict : [String : MPMediaItem]
        if mediaItemNow != nil {
            dict = [MusicPlayer.MEDIA_ITEM_KEY : mediaItemNow!]
        } else {
            dict = [MusicPlayer.MEDIA_ITEM_KEY : self.mediaItemQueue[self.nowPlayingQueueIndex]]
        }
        NSNotificationCenter.defaultCenter().postNotificationName(MusicPlayer.MusicPlayerStateDidChange, object: self, userInfo: dict)
    }
    
    func isPlaying() -> Bool{
        return avPlayer.rate != Float(0.0)
    }
    
    func skipToNextItem(){
        avPlayer.advanceToNextItem()
        
        if(mediaItemNow != nil){
            mediaItemNow = nil
            loadNowPlayingInfoCenter() //TODO: this will fail at -1 index
        }
        else {
            updateNowPlayingIndex()
        }
    }
    
    func skipToPosition(time: CMTime){
        avPlayer.seekToTime(time)
    }
    
    func skipToPreviousItem(){
        mediaItemNow = nil
        if nowPlayingQueueIndex > 0 {
            playItemAtIndex(nowPlayingQueueIndex - 1)
        }
        
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
        if mediaItems.isEmpty {
            return
        }
        
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
    
    func nowPlayingMediaItem() -> MPMediaItem? {
        if mediaItemNow != nil {
            return mediaItemNow!
        }
        
        if nowPlayingQueueIndex == MusicPlayer.DEFAULT_INDEX {
            return nil
        } else {
           return self.mediaItemQueue[self.nowPlayingQueueIndex]
        }
    }
    
    // Returns the unplayed tracks from the queue.
    func remainingMediaItemsInQueue() -> [MPMediaItem]{
        let nextIndex = self.nowPlayingQueueIndex + 1
        if nowPlayingQueueIndex == MusicPlayer.DEFAULT_INDEX || nextIndex >= self.mediaItemQueue.count{
            return []
        }
        return Array(self.mediaItemQueue[nextIndex..<self.mediaItemQueue.count])
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
    
    //This is only exposed so that it can be persisted. 
    func nowPlayingPosition() ->CMTime{
        return avPlayer.currentTime()
    }
    
//    func nowPlayingMediaItem() -> MPMediaItem?{
//        if nowPlayingQueueIndex == MusicPlayer.DEFAULT_INDEX {
//            return nil
//        }
//
//        return mediaItemQueue[nowPlayingQueueIndex]
//    }
    
    //**************
    //TODO! Move this to NowPlayingViewController. That is where the remote control featues are.  
    //!!!!!!!!!!!!!!
    private func loadNowPlayingInfoCenter(){
        
        if (nowPlayingQueueIndex < 0) {
            return
        }
        var mutableDict : [String: AnyObject]
        
        var mediaItemCurrentlyPlaying : MPMediaItem
        if mediaItemNow != nil {
            mediaItemCurrentlyPlaying = mediaItemNow!
        } else {
            mediaItemCurrentlyPlaying = mediaItemQueue[nowPlayingQueueIndex]
        }
        
//        nowPlayingInfoCenter.nowPlayingInfo
        mutableDict = [
            MPMediaItemPropertyArtist:mediaItemCurrentlyPlaying.valueForProperty(MPMediaItemPropertyArtist)!,
            MPMediaItemPropertyTitle:mediaItemCurrentlyPlaying.valueForProperty(MPMediaItemPropertyTitle)!,
//            MPMediaItemPropertyArtist:"\(mediaItemCurrentlyPlaying.valueForProperty(MPMediaItemPropertyAlbumArtist)!)-\(mediaItemCurrentlyPlaying.valueForProperty(MPMediaItemPropertyAlbumTitle)!)",
            MPMediaItemPropertyAlbumArtist:mediaItemCurrentlyPlaying.valueForProperty(MPMediaItemPropertyAlbumArtist)!,
            MPMediaItemPropertyAlbumTitle:mediaItemCurrentlyPlaying.valueForProperty(MPMediaItemPropertyAlbumTitle)!,
          
            MPMediaItemPropertyPlaybackDuration:mediaItemCurrentlyPlaying.valueForProperty(MPMediaItemPropertyPlaybackDuration)!
        ]
        //If there is no art work, you dont want to blow up.
        if let artwork = mediaItemCurrentlyPlaying.valueForProperty(MPMediaItemPropertyArtwork) {
            mutableDict[MPMediaItemPropertyArtwork] = artwork
        }

        nowPlayingInfoCenter.nowPlayingInfo = mutableDict
    }
    
    //Note! The annotation was required because this class doesnt extend NSObject!!
    @objc func onItemDidFinishPlaying(notification: NSNotification){
        if mediaItemNow != nil {
            mediaItemNow = nil
            loadNowPlayingInfoCenter() //TODO: this will fail at -1 index
        } else {
            updateNowPlayingIndex()
        }
    }
    
    //So wrong that this takes so much to do
    func playItemAtIndex(index: Int){
        avPlayer.removeAllItems()
        
        let avPlayerItems = mediaItemQueue.asAVPlayerItems(self, selector: "onItemDidFinishPlaying:")
        for var i = index ; i < avPlayerItems.count ; i++ {
            let avpItem = avPlayerItems[i]
            if avPlayer.canInsertItem(avpItem, afterItem: nil) {
                avpItem.seekToTime(kCMTimeZero) //May not be needed
                avPlayer.insertItem(avpItem, afterItem: nil)
            }
        }
        
        nowPlayingQueueIndex = index
        
        play()
    }
    
    //Play this song right now, dont add it to the queue, but keep the queue in tact
    func playThisItemNow(mediaItem : MPMediaItem){
        
//        mediaItemQueue.insert(mediaItem, atIndex: nowPlayingQueueIndex)
//        
//        avPlayer.removeAllItems()
//        
//        let avPlayerItems = mediaItemQueue.asAVPlayerItems(self, selector: "onItemDidFinishPlaying:")
//        for var i = nowPlayingQueueIndex ; i < avPlayerItems.count ; i++ {
//            let avpItem = avPlayerItems[i]
//            if avPlayer.canInsertItem(avpItem, afterItem: nil) {
//                avpItem.seekToTime(kCMTimeZero) //May not be needed
//                avPlayer.insertItem(avpItem, afterItem: nil)
//            }
//        }
//        
//        play()

//        updateNowPlayingIndex()
        
        mediaItemNow = mediaItem
        
        print(mediaItem.title)
        
        let index = nowPlayingQueueIndex
        avPlayer.removeAllItems()
        
        var tempMediaItemQueue : [MPMediaItem] = []
        tempMediaItemQueue.append(mediaItem)
        tempMediaItemQueue.appendContentsOf(mediaItemQueue[nowPlayingQueueIndex..<mediaItemQueue.count])
        
        let avPlayerItems = tempMediaItemQueue.asAVPlayerItems(self, selector: "onItemDidFinishPlaying:")
        for var i = index ; i < avPlayerItems.count ; i++ {
            let avpItem = avPlayerItems[i]
            if avPlayer.canInsertItem(avpItem, afterItem: nil) {
                avpItem.seekToTime(kCMTimeZero) //May not be needed
                avPlayer.insertItem(avpItem, afterItem: nil)
            }
        }
//        play()
        notifyNowPlayingDidChange()
    }
    
    
    private func updateNowPlayingIndex(){
        if nowPlayingQueueIndex + 1 >= mediaItemQueue.count {
            nowPlayingQueueIndex = MusicPlayer.DEFAULT_INDEX
        }
        else {
            nowPlayingQueueIndex++
        }
        loadNowPlayingInfoCenter() //TODO: this will fail at -1 index
    }
    
    private func notifyNowPlayingDidChange(){
        print("Nofity debug now playing index: \(nowPlayingQueueIndex)")
        
        if mediaItemNow != nil {
//            return mediaItemNow!
            let dict = [MusicPlayer.MEDIA_ITEM_KEY : mediaItemNow!]
            NSNotificationCenter.defaultCenter().postNotificationName(MusicPlayer.MusicPlayerNowPlayingItemDidChange, object: self, userInfo: dict)
        }
        
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
    
    func asSongIds() -> [NSNumber] {
        var ids : [NSNumber] = []
        for song in self{
            let id = (song as! MPMediaItem).valueForProperty(MPMediaItemPropertyPersistentID) as! NSNumber
            ids.append(id)
        }
        return ids
    }
}

extension AVPlayerItem {
    func installDidFinishNotification(observer: AnyObject, selector: Selector){
        NSNotificationCenter.defaultCenter().addObserver(observer, selector: selector, name: AVPlayerItemDidPlayToEndTimeNotification, object: self)
    }
}

extension NSNotification {
    func isNotificationForMyAlbum(albumId : NSNumber) ->Bool{
        if let dict = self.userInfo {
            let nowPlayingItem = dict[MusicPlayer.MEDIA_ITEM_KEY]
            
            if let nowPlayingAlbumId = nowPlayingItem?.valueForProperty(MPMediaItemPropertyAlbumPersistentID) as? NSNumber{
                if albumId == nowPlayingAlbumId {
                    return true
                }
            }
        }
        return false
    }
}