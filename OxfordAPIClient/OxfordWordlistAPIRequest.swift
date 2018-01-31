//
//  OxfordWordlistAPIRequest.swift
//  Scrambled Messenger
//
//  Created by Aleksander Makedonski on 1/30/18.
//  Copyright © 2018 Aleksander Makedonski. All rights reserved.
//

import Foundation


class OxfordWordlistAPIRequest: OxfordAPIRequest{
    
    
    init(forSourceLanguage sourceLanguage: OxfordAPILanguage, forDomainFilters domainFilters: [OxfordDomain], forRegionFilters regionFilters: [OxfordRegion], forRegisterFilters registerFilters: [OxfordLanguageRegister], forLexicalCategoryFilters lexicalCategoryFilters: [OxfordLexicalCategory]){
        
        let domainFilterStrings = domainFilters.map({$0.rawValue})
        let regionFilterStrings = regionFilters.map({$0.rawValue})
        let registerFilterStrings = registerFilters.map({$0.rawValue})
        let lexicalCategoryStrings = lexicalCategoryFilters.map({$0.rawValue})
        
        let mDomainFilters = domainFilterStrings.isEmpty ? [] : [OxfordAPIEndpoint.OxfordAPIFilter.domains(domainFilterStrings)]
        
        let mRegionFilters = regionFilterStrings.isEmpty ? [] : [OxfordAPIEndpoint.OxfordAPIFilter.regions(regionFilterStrings)]
        
        let mRegisterFilters = registerFilterStrings.isEmpty ? [] : [OxfordAPIEndpoint.OxfordAPIFilter.registers(registerFilterStrings)]
        
        let mLexCategoryFilters = lexicalCategoryStrings.isEmpty ? [] : [OxfordAPIEndpoint.OxfordAPIFilter.lexicalCategory(lexicalCategoryStrings)]
        
        let allFilters = mDomainFilters + mRegionFilters + mRegisterFilters + mLexCategoryFilters
        
        super.init(withQueryWord: String(), forRegions: nil, forLanguage: .English, withFilterForDictionaryEntryLookup: nil, withQueryFilters: allFilters)!
        
        self.endpoint = .wordlist
        
        
    }
   
    
    override func getURLString() -> String {
        
        var urlStr = getURLStringFromAppendingEndpointSpecifier(relativeToURLString: baseURLString)
        
        urlStr = getURLStringFromAppendingLanguageSpecifier(relativeToURLString: urlStr)
        
        
        if let allFilters = self.queryFilters, allFilters.count > 0{
            
            addFilters(filters: allFilters, toURLString: &urlStr)
            
        } else {
            
            urlStr.removeLast()
        }
        
    
        
        return urlStr
    }
}
