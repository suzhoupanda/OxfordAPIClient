//
//  OxfordLemmatronAPIRequest.swift
//  OxfordAPIClient
//
//  Created by Aleksander Makedonski on 1/31/18.
//  Copyright © 2018 Aleksander Makedonski. All rights reserved.
//


import Foundation

class OxfordLemmatronAPIRequest: OxfordAPIRequest{
    
    
    
    init(withInflectedWord inflectedWord: String, withFilters queryFilters: [OxfordAPIEndpoint.OxfordAPIFilter]?, withQueryLanguage queryLanguage: OxfordAPILanguage = .English){
        
        super.init(withQueryWord: inflectedWord, forRegions: nil, forLanguage: queryLanguage, withFilterForDictionaryEntryLookup: nil, withQueryFilters: queryFilters)!
        
        self.endpoint = OxfordAPIEndpoint.inflections
      
        
    }
    
    override func getURLString() -> String {
        
        
        
        var urlStr = getURLStringFromAppendingEndpointSpecifier(relativeToURLString: baseURLString)
        
        urlStr = getURLStringFromAppendingLanguageSpecifier(relativeToURLString: urlStr)
        
        urlStr = getURLStringFromAppendingQueryWord(relativeToURLString: urlStr)
        
        if let allFilters = self.queryFilters{
            
            addFilters(filters: allFilters, toURLString: &urlStr)
            
            
        }
        
        if let lastChar = urlStr.last, lastChar == "/"{
            urlStr.removeLast()
        }
        
        return urlStr
    }
}

