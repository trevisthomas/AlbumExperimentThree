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
    
    private static let savedDataKey : String = "savedDataKey"
    
    private static let lastPlayedAlbumsKey = "lastPlayedAlbums"
    private static let newAlbumsKey = "newAlbums"
    private static let nowPlayingQueueKey = "nowPlayingQueue"
    private static let nowPlayingIndexKey = "nowPlayingIndex"
    private static let playbackPositionKey = "playbackPosition"
    
    var lastPlayedAlbums: [NSNumber]
    private var newAlbums: [NSNumber]
    var nowPlayingQueue: [NSNumber]
    var nowPlayingIndex: Int
    var playbackPosition: CMTime
    private var newAlbumCheckPerformed = false
    private var newAlbumCheckInProgress = false
    
    private var newAlbumObservers: [([NSNumber] -> ())] = []
    
    override init(){
        lastPlayedAlbums = []
        newAlbums = []
        nowPlayingQueue = []
        nowPlayingIndex = -1
        playbackPosition = CMTime()
    }
    
    static func loadOrCreateSavedDataInstance() -> SavedData{
        var savedData : SavedData
        //Unarchive savedData
        if let data = NSUserDefaults.standardUserDefaults().objectForKey(savedDataKey) as? NSData {
            savedData = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! SavedData
        } else {
            //This should only happen if the data doesnt exist. Note:  The savedData class has a failsafe internaly that should handle creating a new object even if it failes to load the file.
            savedData = SavedData()
        }
        
        return savedData
    }
    
    //This still doesnt feel perfect, but at least i'm not using the singleton to do the save.
    func saveState(musicPlayer : MusicPlayer){
        
        //This feels so wrong.  This class should just be the system of record for this data.
        nowPlayingQueue = musicPlayer.mediaItemQueue.asSongIds()
        nowPlayingIndex = musicPlayer.nowPlayingQueueIndex
        playbackPosition = musicPlayer.nowPlayingPosition()
        
        let data = NSKeyedArchiver.archivedDataWithRootObject(self)
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: SavedData.savedDataKey)
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
//        coder.encodeObject([] as [NSNumber], forKey: SavedData.newAlbumsKey) //Saving blank for debuging
        
        coder.encodeObject(self.nowPlayingQueue, forKey: SavedData.nowPlayingQueueKey)
        coder.encodeObject(self.nowPlayingIndex, forKey: SavedData.nowPlayingIndexKey)
        coder.encodeObject(CMTimeGetSeconds(self.playbackPosition), forKey: SavedData.playbackPositionKey)
        
    }
    
    func determineNewAlbums(callback:([NSNumber])->()){
        
        //For debugging, removing an item
//        newAlbums.removeFirst(3)
        
        print(newAlbums.count)
        
        var removed : [NSNumber] = []
        
        removed.append(newAlbums.removeFirst())
        removed.append(newAlbums.removeFirst())
        removed.append(newAlbums.removeFirst())
        
        let albums = MusicLibrary.instance.queryAlbumsByPersistenceIDs(removed)
        for a in albums {
            print("\(a.artist) - \(a.title)")
        }
        
        print("After: \(newAlbums.count)")
        
        //Removing the first albums so that they appear later
        
        callback(newAlbums) //Give the caller current state, no matter what.
        
//        guard newAlbumCheckPerformed else {
//            
//        }
        
        if newAlbumCheckPerformed {
            return //Nothing to do
        } else {
            //wait for results
            newAlbumObservers.append(callback)
        }
        
        //If it hasn't been done, and hasn't started... start it
        if newAlbumCheckPerformed == false && newAlbumCheckInProgress == false {
            //If the newItems array is empty i try to load them from the xml.  If it's not, i update from MediaItems
            if newAlbums.isEmpty {
                //Try to load them from itunes xml
                {self.loadNewAlbumsFromItunesXml()} ~> {self.notifyNewAlbumObservers($0)}
            } else {
                //Check for new albums in mediaItems
                {self.updateNewAlbumsFromMediaItems()} ~> {self.insertNewAlbumsAndNotifyObservers($0)}
            }
        }
    }
    
    private func insertNewAlbumsAndNotifyObservers(newAlbumsToInsert : [NSNumber]){
//        var updatedAlbums: [NSNumber] = []
        
//        updatedAlbums.appendContentsOf(newAlbumsToInsert)
//        updatedAlbums.appendContentsOf(newAlbums)
//        
//        let albums = MusicLibrary.instance.queryAlbumsByPersistenceIDs(newAlbumsToInsert)
//            for a in albums {
//                print("\(a.artist) - \(a.title)")
//            }
//        
        
//        notifyNewAlbumObservers(updatedAlbums)
        
        newAlbums.insertContentsOf(newAlbumsToInsert, at: 0)
        //Below only notifes of the delta.
        for callback in newAlbumObservers {
            callback(newAlbumsToInsert)
        }
    }
    
    private func notifyNewAlbumObservers(updatedNewAlbums : [NSNumber]){
        newAlbums = updatedNewAlbums
        for callback in newAlbumObservers {
            callback(newAlbums)
        }
    }
    //Not on main thread!!
    private func loadNewAlbumsFromItunesXml() -> [NSNumber]{
        let albumsFromXml = MusicLibrary.instance.loadSortedAlbumIdsFromiTunesLibrary()
        let stuffNotFoundInXml = MusicLibrary.instance.findAlbumIdsNotInList(albumsFromXml)
        
        //This extra weird stuff is to make sure that the list we save includes every album that MPMediaItem sees before saving it
        var albums : [NSNumber] = []
        albums.appendContentsOf(albumsFromXml)
        albums.appendContentsOf(stuffNotFoundInXml)
        
        return albums
    }
    
    //Not on main thread!!
    private func updateNewAlbumsFromMediaItems() -> [NSNumber]{
        //Trevis... it's probably not be cool to touch newAlbums on another thread.
        return MusicLibrary.instance.findAlbumIdsNotInList(newAlbums)
        
    }

}