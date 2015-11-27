//
//  MusicLibrary.swift
//  Album Experiment
//
//  Created by Trevis Thomas on 10/10/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//

import Foundation
import MediaPlayer

class MusicLibrary {
    
    static let instance = MusicLibrary()
    private var artistAlbumCount : [String: Int];
    
    init () {
        artistAlbumCount = [String: Int]()
        
        let query = MPMediaQuery.albumsQuery()
        for albumCollection in query.collections! {
            let item = albumCollection.representativeItem!
            let albumArtist = getArtistNamm(fromMediaItem: item)
            if let count = artistAlbumCount[albumArtist]{
                artistAlbumCount[albumArtist] = count + 1
            } else {
                artistAlbumCount[albumArtist] = 1
            }
        }
    }
    
    private func getArtistNamm(fromMediaItem item : MPMediaItem) ->String{
        var albumArtist = item.valueForProperty(MPMediaItemPropertyAlbumArtist) as? String
        if(albumArtist == nil){
            albumArtist = item.valueForProperty(MPMediaItemPropertyPodcastTitle) as? String
        }
        if(albumArtist == nil){
            albumArtist = "<None>"
        }
        return albumArtist!
    }
    
//    func getAlbumCount(forArtist artist : String) ->Int{
//        return artistAlbumCount[artist]!
//    }
    
    
//    func getArtistCollectionForGenre(genreTitle genre : String) ->[MPMediaItemCollection]{
//        let query = MPMediaQuery.genresQuery()
//        
//        let predicate = MPMediaPropertyPredicate(value: genre, forProperty: MPMediaItemPropertyGenre)
//        query.filterPredicates = Set(arrayLiteral: predicate)
//        query.groupingType = .AlbumArtist
//        return query.collections!
//    }
    
//    func getGenre(atGenreIndex index: Int) ->String{
//        let query = MPMediaQuery.genresQuery()
//        let mediaItemCollection = query.collections?[index];
//        
//        let mediaItem = mediaItemCollection?.representativeItem
//        let genre = mediaItem?.valueForProperty(MPMediaItemPropertyGenre) as! String
//        return genre
//    }
    
//    func getAlbumCollectionForArtist(artistTitle artist : String) ->[MPMediaItemCollection]{
//        let query = MPMediaQuery.genresQuery()
//        let predicate = MPMediaPropertyPredicate(value: artist, forProperty: MPMediaItemPropertyAlbumArtist)
//        query.filterPredicates = Set(arrayLiteral: predicate)
//        query.groupingType = .Album
//        return query.collections!
//    }
    
//    func getArtistTitle(inGenre genre : String, atIndex index : Int) ->String{
//        let artistCollection = MusicLibrary.instance.getArtistCollectionForGenre(genreTitle: genre)
//        let artistItemsCollection = artistCollection[index] //A collection of all songs by the artist i think
//        let mediaItem = artistItemsCollection.representativeItem! //An item to represent the artist
//        let artistTitle = mediaItem.valueForProperty(MPMediaItemPropertyAlbumArtist) as! String
//        return artistTitle
//    }
    
//    func getRepresentitiveMediaItem(forArtist artist : String, atAlbumIndex index : Int) ->MPMediaItem{
//        let artistAlbumColletion = getAlbumCollectionForArtist(artistTitle: artist)
//        let albumCollection = artistAlbumColletion[index]
//        return albumCollection.representativeItem!
//    }
    
//    func getAlbum(forArtist artist : String, atAlbumIndex index : Int) ->MPMediaItemCollection{
//        let artistAlbumColletion = getAlbumCollectionForArtist(artistTitle: artist)
//        let albumCollection = artistAlbumColletion[index]
//        return albumCollection
//    }
    
    func getSongsFromAlbum(albumId : NSNumber) ->[SongData]{
//        let albumId = albumIdString as MPMediaItemPropertyAlbumPersistentID
        let query = MPMediaQuery.genresQuery()
//        return []
        let predicate = MPMediaPropertyPredicate(value: albumId, forProperty: MPMediaItemPropertyAlbumPersistentID)
        query.filterPredicates = Set(arrayLiteral: predicate)
        query.groupingType = .AlbumArtist
        
        var songs : [SongData] = []
        
        for albumCollection in query.collections!{ //There should only be one
            for item in albumCollection.items {
                let song = SongData()
                song.title = item.valueForProperty(MPMediaItemPropertyTitle) as! String
                song.trackNumber = item.valueForProperty(MPMediaItemPropertyAlbumTrackNumber) as! Int
                let duration = item.valueForProperty(MPMediaItemPropertyPlaybackDuration) as! Float
                
                song.duration = formatDuration(duration)
//                cell.detailTextLabel?.text = "\(formatDuration(duration))"

                
                songs.append(song)
            }
        }
        
        return songs
    }
    
    //TODO: Move this function somewhere.
    private func formatDuration(duration : Float) ->String{
        let minutes = Int(floor(duration / 60));
        let secondsFloat = duration - Float(minutes * 60)
        let seconds = String(format: "%02d", Int(round(secondsFloat)))
        
        return "\(minutes):\(seconds)"
    }
    
    func getGenreBundle() ->[GenreData]{
        let query = MPMediaQuery.genresQuery()
        var result = [GenreData]()
        for mediaItemCollection in query.collections!{
            let bundle = GenreData()
            let mediaItem = mediaItemCollection.representativeItem
            let genre = mediaItem?.valueForProperty(MPMediaItemPropertyGenre) as? String
            let songCount = mediaItemCollection.count
            
            //Determine artist count
            let predicateByArtist = MPMediaPropertyPredicate(value: genre, forProperty: MPMediaItemPropertyGenre)
            query.filterPredicates = Set(arrayLiteral: predicateByArtist)
            query.groupingType = .AlbumArtist
            let artistCount = query.collections!.count
            //
            
            //Determine album count
            let predicateByAlbum = MPMediaPropertyPredicate(value: genre, forProperty: MPMediaItemPropertyGenre)
            query.filterPredicates = Set(arrayLiteral: predicateByAlbum)
            query.groupingType = .Album
            let albumCount = query.collections!.count
            
            bundle.detail = "\(artistCount) artists, \(albumCount) albums, \(songCount) songs."
            bundle.title = genre!
            
            //animatedImageWithImages!!!!!
            
//            bundle.art = getRandomArtworkFromCollection(mediaItemCollection)
            bundle.isPodcast = false;
            
            let images = generateRandomArtworkImagesFromCollection(mediaItemCollection)
            bundle.artwork = UIImage.collageImage(CGRect(x: 0, y: 0, width: 200, height: 100), maxImagesPerRow: 4, images: images)
 
//            bundle.artwork = getRandomArtworkFromCollection(mediaItemCollection)
            result.append(bundle)
        }
        
        let bundle = GenreData();
        bundle.title = "Podcast"
        bundle.detail = "\(getPodcasts().count) programs."
        bundle.isPodcast = true
        bundle.artwork = UIImage(named: "album-placeholder")!
        result.append(bundle)
        
        return result;
    }
    
    private func generateRandomArtworkImagesFromCollection(collection : MPMediaItemCollection) -> [UIImage]{
        //var v = shuffle(collection)
        let indexes = uniqueRandoms(8, minNum: 0, maxNum: UInt32(collection.count))
        
        var images : [UIImage] = []
        for i in indexes{
            if i >= collection.count{
                images.append(UIImage(named: "album-placeholder")!)
                continue
            }
            let item = collection.items[i]
            if(item.valueForProperty(MPMediaItemPropertyArtwork) == nil){
                images.append(UIImage(named: "album-placeholder")!)
            } else {
                let artwork = item.valueForProperty(MPMediaItemPropertyArtwork) as! MPMediaItemArtwork
                images.append(artwork.imageWithSize(CGSize(width: 500, height: 500))!)
            }
            
        }
        return images
    }
    
    private func uniqueRandoms(numberOfRandoms: Int, minNum: Int, maxNum: UInt32) -> [Int] {
        var uniqueNumbers = Set<Int>()
        while uniqueNumbers.count < numberOfRandoms {
            uniqueNumbers.insert(Int(arc4random_uniform(maxNum + 1)) + minNum)
        }
        return Array(uniqueNumbers).shuffle
    }
    
    func getRandomArtworkFromCollection(collection : MPMediaItemCollection) ->UIImage?{
        let randomIndex = arc4random_uniform(UInt32(collection.count))
        let item = collection.items[Int(randomIndex)]
        
        if(item.valueForProperty(MPMediaItemPropertyArtwork) == nil){
            print("nil")
            return UIImage(named: "album-placeholder")
        }
        let artwork = item.valueForProperty(MPMediaItemPropertyArtwork) as! MPMediaItemArtwork
        
        return artwork.imageWithSize(CGSize(width: 500, height: 500))
        
    }

    
    func getPodcasts() ->[MPMediaItemCollection]{
        let query = MPMediaQuery.podcastsQuery()
        return query.collections!
    }
    
    func getPodcastEpisodes(index : Int) ->MPMediaItemCollection{
        let query = MPMediaQuery.podcastsQuery()
        return (query.collections?[index])!
    }
    
    /*
    This implementation is intended to back the CollectionView based Album page.  The goal is to create a dictionary keyed by 
    the first letter of the artists name.  The value is an array containing a sorted list of AlbumData. Some of the album data objects are artist name only, the others represent an album. This was built to feed the ContainerView that i intend to use to present these.
    */
    func getArtistBundle(genre : String) ->[String : [AlbumData]]{
        let query = MPMediaQuery.genresQuery()
        let predicate = MPMediaPropertyPredicate(value: genre, forProperty: MPMediaItemPropertyGenre)
        query.filterPredicates = Set(arrayLiteral: predicate)
        query.groupingType = .Album
        let albumCollections = query.collections!
        
        var albumArray : [AlbumData] = [AlbumData] () // = [AlbumData?](count: albumCollections.count, repeatedValue: nil)
        for album in albumCollections {
            
            albumArray.append(loadAlbumData(fromAlbum: album))
        }
        let sortedAlbumArray = albumArray.sort(){$0.artist < $1.artist}
        
        var indexedBundle = [String : [AlbumData]]()
        var previousArtist : String = ""
        for album in sortedAlbumArray{
            //Get his container
            let firstLetter : String = album.sortableArtist[0]
            
            if indexedBundle[firstLetter] == nil{
                indexedBundle[firstLetter] = [AlbumData]()
            }
            
            //Handle title change
            if previousArtist != album.sortableArtist{
                previousArtist = album.sortableArtist
                indexedBundle[firstLetter]?.append(AlbumData(title: album.artist))
            }
            
            //Add him
            indexedBundle[firstLetter]?.append(album)
        }
  
        //Debug: Dump
        let keys = indexedBundle.keys.sort()
        for key in keys {
            let value = indexedBundle[key]!
            print(value)
        }
        return indexedBundle

    }
    
    private func loadAlbumData(fromAlbum album : MPMediaItemCollection) -> AlbumData{
        let db = AlbumData()
        let props : Set<String> = [MPMediaItemPropertyAlbumTitle ,MPMediaItemPropertyPodcastTitle, MPMediaItemPropertyAlbumArtist, MPMediaItemPropertyArtwork, MPMediaItemPropertyReleaseDate, MPMediaItemPropertyAlbumPersistentID]
        
        let item = album.representativeItem!
        db.trackCount = album.count
        item.enumerateValuesForProperties(props) {
            (str : String, obj : AnyObject, bool : UnsafeMutablePointer<ObjCBool>) in
            switch str{
            case MPMediaItemPropertyAlbumArtist:
                // After hours of fighting the below if block is the first thing that i have found that can handle when the AnyObject is wrapped arround 0x0.  Everything else blew up.  The answer wasn't directly to my question but i did figure it out from this post http://nshipster.com/swift-literal-convertible/
                if(obj as? NSObject == .None){
                    print ("Album Artist: AnyObject was 0x0" )
                    db.artist = "Untitled"
                }
                else if let _ = obj as? String{
//                    print ("Album Artist: \(obj)" )
                    db.artist = obj as! String
                } else {
                    print ("Album Artist: not null and not a string." )
                }
                
            case /*MPMediaItemPropertyPodcastTitle,*/ MPMediaItemPropertyAlbumTitle:
                db.title = obj as! String
//            case MPMediaItemPropertyAlbumTrackCount:
//                db.trackCount = obj as! Int
            case MPMediaItemPropertyArtwork:
                db.art = obj as! MPMediaItemArtwork
            case MPMediaItemPropertyReleaseDate:
                db.releaseDate = obj as! NSDate
                
            case MPMediaItemPropertyAlbumPersistentID:
                db.albumId = obj as! NSNumber
            default:
                break
                
            }
        }
        
        return db
        
    }
    
    func mostRecientlyAddedAlbums() -> [AlbumData] {
        let query = MPMediaQuery.songsQuery()
        let items = query.items
        
        
        
        //Sort the albums by the last played dtae
        let sorter = NSSortDescriptor(key: MPMediaItemPropertyLastPlayedDate, ascending: false)
        let sortedItems = (items! as NSArray).sortedArrayUsingDescriptors([sorter])
        
        //Get the persistenec id's of those albums
        var albumIds : [NSNumber] = []
        for item in sortedItems as! [MPMediaItem] {
            
            let id = item.valueForProperty(MPMediaItemPropertyAlbumPersistentID) as! NSNumber
            if albumIds.contains(id) {
                continue
            }
            albumIds.append(id)
            if albumIds.count == 6 {//Max album count
                break
            }
            
        }
        
        return queryAlbumsByPersistenceIDs(albumIds)
    }
    
    //This hack was added initally for AlbumHistoryView
    func queryAlbumByPersistenceID(albumId : NSNumber) -> AlbumData {
        return queryAlbumsByPersistenceIDs([albumId]) [0]
    }
    
    
    private func queryAlbumsByPersistenceIDs(albumIds: [NSNumber]) ->[AlbumData] {
        var albums : [AlbumData] = []
        let query = MPMediaQuery.genresQuery()
        query.groupingType = .Album
        
        for id in albumIds {
            let predicate = MPMediaPropertyPredicate(value: id, forProperty: MPMediaItemPropertyAlbumPersistentID)
            query.filterPredicates = Set(arrayLiteral: predicate)
            
            for albumCollection in query.collections!{ //There should only be one
                albums.append(loadAlbumData(fromAlbum: albumCollection))
            }
        }
        return albums
    }
    
//    func getMediaItemCollectionForAlbum(albumId : NSNumber) -> MPMediaItemCollection{
//        let query = MPMediaQuery.genresQuery()
//        query.groupingType = .Album
//        
//        let predicate = MPMediaPropertyPredicate(value: albumId, forProperty: MPMediaItemPropertyAlbumPersistentID)
//        query.filterPredicates = Set(arrayLiteral: predicate)
//        return query.collections![0]
//    }

    
    func playAlbum(albumId : NSNumber) {
        let mediaPlayerController = MPMusicPlayerController.systemMusicPlayer()
        
        let query = MPMediaQuery.genresQuery()
        query.groupingType = .Album
        
        let predicate = MPMediaPropertyPredicate(value: albumId, forProperty: MPMediaItemPropertyAlbumPersistentID)
        query.filterPredicates = Set(arrayLiteral: predicate)
        
        mediaPlayerController.setQueueWithQuery(query)
        mediaPlayerController.play()

    }
    
    //Cool debug method for printing out the timing of a method. Found on stack over flow, modified to wrap method with return value
    static func printTimeElapsedWhenRunningCode(title:String, operation:()->(AnyObject))->AnyObject {
        let startTime = CFAbsoluteTimeGetCurrent()
        let retval = operation()
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        //if timeElapsed > 0.00 {
        let time = NSString(format: "%.4f", timeElapsed)
        print("Time elapsed for \(title): \(time) s")
        //}
        return retval
    }

    
}