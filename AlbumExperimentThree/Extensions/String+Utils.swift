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
}