//
//  SavedData.swift
//  AlbumExperimentThree
//
//  Created by Trevis Thomas on 12/3/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//

import Foundation
import AVFoundation

class SavedData : NSObject, NSCoding {
    
    private static let lastPlayedAlbumsKey = "lastPlayedAlbums"
    private static let newAlbumsKey = "newAlbums"
    private static let nowPlayingQueueKey = "nowPlayingQueue"
    private static let nowPlayingIndexKey = "nowPlayingIndex"
    private static let playbackPositionKey = "playbackPosition"
    
    var lastPlayedAlbums: [NSNumber]
    var newAlbums: [NSNumber]
    var nowPlayingQueue: [NSNumber]
    var nowPlayingIndex: Int
    var playbackPosition: CMTime
    
    override init(){
        lastPlayedAlbums = []
        newAlbums = []
        nowPlayingQueue = []
        nowPlayingIndex = -1
        playbackPosition = CMTime()
    }
    
    init(lastPlayedAlbums: [NSNumber], newAlbums: [NSNumber], nowPlayingQueue: [NSNumber], nowPlayingIndex: Int, playbackPosition: CMTime){
        self.lastPlayedAlbums = lastPlayedAlbums
        self.newAlbums = newAlbums
        self.nowPlayingQueue = nowPlayingQueue
        self.nowPlayingIndex = nowPlayingIndex
        self.playbackPosition = playbackPosition
    }
    
    required convenience init?(coder decoder: NSCoder) {
        guard let lastPlayed = decoder.decodeObjectForKey(SavedData.lastPlayedAlbumsKey) as? [NSNumber],
            let newest = decoder.decodeObjectForKey(SavedData.newAlbumsKey) as? [NSNumber],
            let queue = decoder.decodeObjectForKey(SavedData.nowPlayingQueueKey) as? [NSNumber],
            let index = decoder.decodeObjectForKey(SavedData.nowPlayingIndexKey) as? Int,
            let position = decoder.decodeObjectForKey(SavedData.playbackPositionKey) as? Float64
            else {
                print("Saved Data failed to load")
                self.init()
//                return nil
                return
            }
        
        print("Loading Saved Data from coder")
        self.init(lastPlayedAlbums: lastPlayed, newAlbums: newest, nowPlayingQueue: queue, nowPlayingIndex: index, playbackPosition: CMTimeMakeWithSeconds(position, 1))
    }
    
    func encodeWithCoder(coder: NSCoder) {
        print("Writing Saved Data from coder")
        coder.encodeObject(self.lastPlayedAlbums, forKey: SavedData.lastPlayedAlbumsKey)
        coder.encodeObject(self.newAlbums, forKey: SavedData.newAlbumsKey)
        coder.encodeObject(self.nowPlayingQueue, forKey: SavedData.nowPlayingQueueKey)
        coder.encodeObject(self.nowPlayingIndex, forKey: SavedData.nowPlayingIndexKey)
        coder.encodeObject(CMTimeGetSeconds(self.playbackPosition), forKey: SavedData.playbackPositionKey)
        
    }
}