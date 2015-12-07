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
    
    private var foundPersistenceId : Bool = false
    private var loadedPersistenceId : Bool = false
    private var foundDateAdded : Bool = false
    private var loadedDateAdded : Bool = false
    private var currentMeta : AdditionalTrackMetaData? = nil
    
    var metaDataDictionary: [NSNumber: NSDate] = [:]
   
    let dateFormatter : NSDateFormatter = NSDateFormatter()
    
    override init() {
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
//        print("didEnd")
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        
        //Error if currentMeta is nil
        if(foundPersistenceId && !loadedPersistenceId) {
            let i = UInt(string, radix: 16)
            currentMeta!.trackPersistenceId = NSNumber(unsignedInteger: i!)
            loadedPersistenceId = true
        }
        if(foundDateAdded && !loadedDateAdded) {
            
            currentMeta!.dateAdded = dateFormatter.dateFromString(string)
            loadedDateAdded = true
        }
        
        switch (string) {
        case "Track ID":
            
            if currentMeta != nil && songDone() {
                print(currentMeta?.trackPersistenceId)
                metaDataDictionary[(currentMeta?.trackPersistenceId)!] = currentMeta?.dateAdded
            }
            
            foundPersistenceId = false
            foundDateAdded = false
            loadedPersistenceId = false
            loadedDateAdded = false
            
            currentMeta = AdditionalTrackMetaData()
            
            
        case "Persistent ID":
            foundPersistenceId = true
            break
        case "Date Added":
            foundDateAdded = true
            break
        default :
            break
            
        }
    }
    
    private func songDone() ->Bool{
        return foundPersistenceId == true &&
        foundDateAdded == true &&
        loadedPersistenceId == true &&
        loadedDateAdded == true
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
        predicates.append(MPMediaPropertyPredicate(value: albumTitle, forProperty: MPMediaItemPropertyTitle))
        query.filterPredicates = Set(predicates)
        let albumItems = query.items! //Expected to be unique
        //Error check?
        let album = albumItems[0]
        return album.valueForProperty(MPMediaItemPropertyAlbumPersistentID) as? NSNumber
    }

}