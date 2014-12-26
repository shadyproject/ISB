//
//  Extensions.swift
//  ISB
//
//  Created by Christopher Martin on 11/3/14.
//
//

import Foundation

extension String {
    func stringByDecodingUrlFormat() -> NSString {
        let result = self.stringByReplacingOccurrencesOfString("+", withString: " ")
        return result.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
    }
    
    func dictionaryFromQueryStringComponents() -> [String: [String]] {
        var dict = [String: [String]]()
        
        for pair in self.componentsSeparatedByString("&") {
            let kv = pair.componentsSeparatedByString("=")
            if kv.count < 2 {
                continue
            }
            
            let key = kv[0].stringByDecodingUrlFormat()
            let value = kv[1].stringByDecodingUrlFormat()
            
            if var array = dict[key] {
                array.append(value)
            } else {
                dict[key] = [String]()
                dict[key]!.append(value)
            }
            
        }
        
        return dict
    }
}

extension NSURL {
    func dictionaryForQueryString() -> [String: [String]] {
        return self.query!.dictionaryFromQueryStringComponents()
    }
}

