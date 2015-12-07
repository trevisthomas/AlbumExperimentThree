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
    
//    private var foundPersistenceId : Bool = false
//    private var loadedPersistenceId : Bool = false
//    private var foundDateAdded : Bool = false
//    private var loadedDateAdded : Bool = false
//    private var currentMeta : AdditionalTrackMetaData? = nil
    
    private let artistKey = "Artist"
    private let albumKey = "Album"
    private let dateAddedKey = "Date Added"
    
    var metaDataArray: [AdditionalTrackMetaData] = []
//    var metaDataDictionary: [NSNumber: NSDate] = [:]
   
    let dateFormatter : NSDateFormatter = NSDateFormatter()
    
    private var foundKey : String?
    
    var currentNodeList : [String: AnyObject] = [:]
    
    
    override init() {
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
//        print("didEnd")
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        
        if foundKey != nil {
            switch (foundKey!){
                case dateAddedKey:
                    currentNodeList[dateAddedKey] = dateFormatter.dateFromString(string)
                case artistKey:
                    currentNodeList[artistKey] = string
                case albumKey:
                    currentNodeList[albumKey] = string
                default :
                    break
                
            }
            foundKey = nil
        } else {
            
            foundKey = string
            
            if foundKey == "Track ID" {
                if currentNodeList.count >= 3 {
                    
                    
                    let albumTitle = currentNodeList[albumKey] as! String
                    let artist = currentNodeList[artistKey] as! String
                    let dateAdded = currentNodeList[dateAddedKey] as! NSDate
                    if let albumId = lookUpAlbum(albumTitle, artist: artist) {
//                        print("Loading \(artist) - \(albumTitle) \(albumId) \(dateAdded)")
//                        metaDataDictionary[albumId] = dateAdded //Since these are albums, it could already exist because the xml is for tracks
                        
                        metaDataArray.append(AdditionalTrackMetaData(dateAdded: dateAdded, albumId: albumId))
                    } else {
                        print("Got bad data in \(artist) - \(albumTitle)")
                    }
                }
                
                currentNodeList.removeAll() //When we see a "Track ID" we're done
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
    }
    
    func lookUpAlbum(albumTitle: String, artist: String) -> NSNumber?{
        let query = MPMediaQuery.albumsQuery()
//        query.groupingType = .Album //Hm, is this necessary?
        var predicates : [MPMediaPropertyPredicate] = []
        predicates.append(MPMediaPropertyPredicate(value: artist, forProperty: MPMediaItemPropertyAlbumArtist))
        predicates.append(MPMediaPropertyPredicate(value: albumTitle, forProperty: MPMediaItemPropertyAlbumTitle))
        query.filterPredicates = Set(predicates)
        let albumItems = query.items! //Expected to be unique
        //Error check?
        if albumItems.count == 0 {
            return nil
        }
        let album = albumItems[0]
        return album.valueForProperty(MPMediaItemPropertyAlbumPersistentID) as? NSNumber
    }

}