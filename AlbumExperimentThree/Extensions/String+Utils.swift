//
//  String+Utils.swift
//  Album Experiment
//
//  Created by Trevis Thomas on 10/17/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//  http://stackoverflow.com/questions/24092884/get-nth-character-of-a-string-in-swift-programming-language
//
//

import Foundation

extension String {
    static private let articlesArray = ["a ", "an ", "the "]
    
    subscript (i: Int) -> Character {
        return self[self.startIndex.advancedBy(i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        return substringWithRange(Range(start: startIndex.advancedBy(r.startIndex), end: startIndex.advancedBy(r.endIndex)))
    }
    
    func sortableString() -> String{
        let str = self.lowercaseString
        for article in String.articlesArray {
            let range = str.rangeOfString(article)
            if(range != nil && (range?.startIndex == str.startIndex)){
                return str.substringFromIndex((range?.endIndex)!)
                
            }
        }
        return str
    }
    
    static func convertSecondsToHHMMSS( timeInSeconds : Double) -> String{
        let currentHours = Int(timeInSeconds / 3600);
        let currentMinutes = Int((timeInSeconds / 60) - Double(currentHours)*60);
        let currentSeconds = Int(timeInSeconds % 60);
        if currentHours > 0 {
            return String(format:"%i:%02d:%02d", currentHours, currentMinutes, currentSeconds)
        } else {
            return String(format:"%d:%02d",currentMinutes, currentSeconds)
        }
    }
}