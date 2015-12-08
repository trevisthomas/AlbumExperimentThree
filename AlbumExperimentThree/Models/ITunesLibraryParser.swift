//
//  ITunesLibraryParser.swift
//  AlbumExperimentThree
//
//  Created by Trevis Thomas on 12/6/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//

import Foundation
import MediaPlayer

class ITunesLibraryParser : NSObject, NSXMLParserDelegate {
    
    
    private let artistKey = "Artist"
    private let albumKey = "Album"
    private let dateAddedKey = "Date Added"
    
    private var currentParsedElement : String = ""
    private var weAreInsideOfAnAlbum = false
    private var path : [String] = []
    
    private var artistName = ""
    private var albumTitle = ""
    private var albumArtist = ""
    private var dateAdded = NSDate()
    
    private var nextElementIsItunesValue = false
    private var thisElementIsItunesKey = false
    private var iTunesElementKey = ""
    
    
    //Learn how to preallocate an array in swift
//    var metaDataArray: [AdditionalTrackMetaData] = []
    
    private var foundItemsDict : [AlbumTitleArtistHashKey: AdditionalTrackMetaData] = [:]
   
    let dateFormatter : NSDateFormatter = NSDateFormatter()
    
    
    
    override init() {
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
//        print("didEnd")
        
        path.removeLast()
        
        if weAreInsideOfAnAlbum {
            if thisElementIsItunesKey {
                thisElementIsItunesKey = false
                nextElementIsItunesValue = true
            } else if nextElementIsItunesValue {
                nextElementIsItunesValue = false
                iTunesElementKey = ""
            }
            
            if path.count == 3 && path.last == "dict" {
                
                
//                print("Create \(artistName) - \(albumTitle) \(dateAdded)")
                
                let key = AlbumTitleArtistHashKey(artistName: artistName, albumTitle: albumTitle)
                
                if let _ = foundItemsDict[key]{
                    //Exists
//                    print("Exists: \(key.albumTitle)")
                } else {
                    //Adding
                    print("Adding: \(key.albumTitle)")
                    
                    if let albumId = lookUpAlbum(albumTitle, artist: artistName) {
                        foundItemsDict[key] = AdditionalTrackMetaData(dateAdded: dateAdded, albumId: albumId)
                    } else {
                        print("Got bad data in \(artistName) - \(albumTitle) \(dateAdded)")
                        foundItemsDict[key] = AdditionalTrackMetaData(dateAdded: dateAdded, albumId: 0) //To save from looking it up again
                    }
                    
                    
                }
                
                
//                if let albumId = lookUpAlbum(albumTitle, artist: artistName) {
////                        print("Loading \(artist) - \(albumTitle) \(albumId) \(dateAdded)")
////                        metaDataDictionary[albumId] = dateAdded //Since these are albums, it could already exist because the xml is for tracks
//
//                    
//                    
////                    if foundItemsDict.contains(<#T##predicate: ((AlbumTitleArtistHashKey, AdditionalTrackMetaData)) throws -> Bool##((AlbumTitleArtistHashKey, AdditionalTrackMetaData)) throws -> Bool#>)
//                    foundItemsDict[key] = AdditionalTrackMetaData(dateAdded: dateAdded, albumId: albumId)
//                    metaDataArray.append(AdditionalTrackMetaData(dateAdded: dateAdded, albumId: albumId))
//                } else {
//                    print("Got bad data in \(artistName) - \(albumTitle) \(dateAdded)")
//                    
////                    let albumId = lookUpAlbum(albumTitle, artist: artistName, albumArtist: albumArtist) //DEbug try again
////                    print ("\(albumId)") //Debug
//                }
                
                weAreInsideOfAnAlbum = false
                
                artistName = ""
                albumTitle = ""
                albumArtist = ""
                dateAdded = NSDate()
            }
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        
//        print(path)
        
        if weAreInsideOfAnAlbum {
            if thisElementIsItunesKey {
                iTunesElementKey = string
//                switch string {
//                    case dateAddedKey:
//                        iTunesElementKey = string
//                    case artistKey:
//                        iTunesElementKey = string
//                    case albumKey:
//                        iTunesElementKey = string
//                    default :
//                        break
//                }
            }
            else {
                switch iTunesElementKey {
                    case dateAddedKey:
                        dateAdded = dateFormatter.dateFromString(string)!
                    case artistKey:
                        artistName = artistName + string  //This gets called multiple times per element if there are special characters!!
                    case albumKey:
                        albumTitle = albumTitle + string
                    
                    default :
                        break
                }
            }
        }
        
    }
    

    
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        print("Error \(parseError)")
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
//        print("Element's name is \(elementName)")
//        print("Element's attributes are \(attributeDict)")
//        
        
        path.append(elementName)
        
        if path.count == 4 && path.last == "dict" {
            weAreInsideOfAnAlbum = true
        }
        
        if weAreInsideOfAnAlbum {
            switch elementName {
                case "key":
                    thisElementIsItunesKey = true
                default:
                    break
            }
            
        }

    }
    
    func getSortedAlbumIds() -> [NSNumber] {
        let metaDataArray = foundItemsDict.values.sort(){
            $0.dateAdded.isGreaterThanDate($1.dateAdded)
        }
        
//        var set = Set<NSNumber>()
        var albumIds: [NSNumber] = []
        for meta in metaDataArray{
//            set.insert(meta.albumId)
            
            if meta.albumId == 0 {
                continue //This was a place holder, skip it
            }
            if albumIds.indexOf(meta.albumId) == nil { //Make sure that it's not alreayd here
                albumIds.append(meta.albumId)
            }
        }
//        return Array(set)
        return albumIds
    }
    
    func lookUpAlbum(albumTitle: String, artist: String) -> NSNumber?{
        let query = MPMediaQuery.albumsQuery()
        var predicates : [MPMediaPropertyPredicate] = []
        query.groupingType = .Album
        
        //Trevis:  For some rason using both values caused some lookups to fail.  However, not using both predicates means that two artists with the same album title could have unexpected results
//        predicates.append(MPMediaPropertyPredicate(value: artist, forProperty: MPMediaItemPropertyArtist))
        predicates.append(MPMediaPropertyPredicate(value: albumTitle, forProperty: MPMediaItemPropertyAlbumTitle))
        query.filterPredicates = Set(predicates)
        var albumItems = query.items! //Expected to be unique
        
        //Error check?
        if albumItems.count == 0 {
            return nil
        }
    
        let album = albumItems[0]
        return album.valueForProperty(MPMediaItemPropertyAlbumPersistentID) as? NSNumber
    }

}