//
//  OxfordThesaurusAPIRequest.swift
//  Scrambled Messenger
//
//  Created by Aleksander Makedonski on 1/30/18.
//  Copyright © 2018 Aleksander Makedonski. All rights reserved.
//

import Foundation


class OxfordThesaurusAPIRequest: OxfordAPIRequest{
    
    /** Additional stored properties for making request to the Thesaurus API **/
    
    private var hasRequestedSynonyms: Bool = false
    private var hasRequestAntonyms: Bool = false
    
    init(withWord queryWord: String, isAntonymRequest: Bool, isSynonymRequest: Bool, forLanguage queryLanguage: OxfordAPILanguage = .English){
        
        super.init(withQueryWord: queryWord, forRegions: nil, forLanguage: .English, withFilterForDictionaryEntryLookup: nil, withQueryFilters: nil)!
        
        self.hasRequestAntonyms = isAntonymRequest
        self.hasRequestedSynonyms = isSynonymRequest
        
        
    }
    /** Appends the Thesaurus query parameters to the ULR string; **/
    
    
    override func getURLString() -> String {
        
        var urlString = self.baseURLString
        
        urlString  = getURLStringFromAppendingEndpointSpecifier(relativeToURLString: urlString)
        
        urlString = getURLStringFromAppendingLanguageSpecifier(relativeToURLString: urlString)
        
        urlString = getURLStringFromAppendingQueryWord(relativeToURLString: urlString)
        
        urlString = getURLStringFromAppendingThesaurusQueryParameters(relativeToURLString: urlString)
        
        
        return urlString
    }
    
    private func getURLStringFromAppendingThesaurusQueryParameters(relativeToURLString urlString: String) -> String{
        
        
        if(hasRequestedSynonyms && hasRequestAntonyms){
            
            let finalURLString = urlString.appending("synonyms;antonyms")
            
            return finalURLString
            
        } else if(hasRequestedSynonyms){
            
            let finalURLString = urlString.appending("synonyms")
            
            return finalURLString
            
        } else if(hasRequestAntonyms){
            
            let finalURLString = urlString.appending("antonyms")
            
            return finalURLString
            
            /** Return synonyms by default **/
        } else {
            
            let finalURLString = urlString.appending("synonyms")
            
            return finalURLString
        
        }
        
        
        
        
    }
}
