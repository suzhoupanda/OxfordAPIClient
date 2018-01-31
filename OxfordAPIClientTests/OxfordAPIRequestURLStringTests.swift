//
//  OxfordAPIRequestURLStringTests.swift
//  OxfordAPIClientTests
//
//  Created by Aleksander Makedonski on 1/31/18.
//  Copyright © 2018 Aleksander Makedonski. All rights reserved.
//

import XCTest
@testable import OxfordAPIClient

class OxfordAPIRequestURLStringTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testOxfordUtilityAPIRequestURLString(){
        
        let apiRequest1 = OxfordUtilityAPIRequest(withUtilityRequestEndpoint: .domains, andWithTargetLanguage: nil, andWithEndpointForAllFiltersRequest: nil)
        
        let urlString1 = apiRequest1.getURLString()
        
        XCTAssertEqual(urlString1, "https://od-api.oxforddictionaries.com/api/v1/domains/en")
        
        let apiRequest2 = OxfordUtilityAPIRequest(withUtilityRequestEndpoint: .filters, andWithTargetLanguage: nil, andWithEndpointForAllFiltersRequest: OxfordAPIEndpoint.entries)
        
        let urlString2 = apiRequest2.getURLString()
        
    
        XCTAssertEqual(urlString2, "https://od-api.oxforddictionaries.com/api/v1/filters/entries")
    
    }
    
    func testOxfordWordlistAPIRequestURLString(){
        
        let apiRequest1 = OxfordWordlistAPIRequest(forSourceLanguage: .English, forDomainFilters: [.alcoholic], forRegionFilters: [], forRegisterFilters: [], forLexicalCategoryFilters: [])
        
        let urlString1 = apiRequest1.getURLString()
        
        XCTAssertEqual(urlString1, "https://od-api.oxforddictionaries.com/api/v1/wordlist/en/domains=alcoholic")
        
        let apiRequest2 = OxfordWordlistAPIRequest(forSourceLanguage: .English, forDomainFilters: [], forRegionFilters: [], forRegisterFilters: [.coarse_slang], forLexicalCategoryFilters: [])
        
        let urlString2 = apiRequest2.getURLString()

        XCTAssertEqual(urlString2, "https://od-api.oxforddictionaries.com/api/v1/wordlist/en/registers=coarse_slang")

        
        
    }
    
    
    func testOxfordSentencesAPIRequestURLString(){
        
        let apiRequest = OxfordSentencesAPIRequest(withQueryWord: "save")
        
        let urlString = apiRequest.getURLString()
        
        XCTAssertEqual(urlString, "https://od-api.oxforddictionaries.com/api/v1/entries/en/save/sentences")
    
    }
    
    func testOxfordThesaurusAPIRequestURLStringl(){
        
        let apiRequest1 = OxfordThesaurusAPIRequest(withWord: "love", isAntonymRequest: true, isSynonymRequest: true)
        
        
        
        let urlString1 = apiRequest1.getURLString()
        
        XCTAssertEqual(urlString1, "https://od-api.oxforddictionaries.com/api/v1/entries/en/love/synonyms;antonyms")
        
    }
    
    func testOxfordAPIRequestURLStringWithoutDictionaryLookupFilters(){
        
        let apiRequest1 = OxfordAPIRequest(withQueryWord: "love", forRegions: nil, forLanguage: .English, withFilterForDictionaryEntryLookup: nil, withQueryFilters: nil)
        
        
        XCTAssertNotNil(apiRequest1)
        
        if let nonNilRequest1 = apiRequest1{
            
            let urlString1 = nonNilRequest1.getURLString()
            
            XCTAssertEqual(urlString1, "https://od-api.oxforddictionaries.com/api/v1/entries/en/love")
        }

    }
    
    func testOxfordAPIRequestURLStringWithDictionaryLookupFilters(){
        
        
        let apiRequest1 = OxfordAPIRequest(withWord: "love", withDictionaryEntryLookupFilter: .definitions([]), forRegions: nil, forLanguage: .English)
        
        XCTAssertNotNil(apiRequest1)
        
        if let nonNilRequest1 = apiRequest1{
        
            let urlString1 = nonNilRequest1.getURLString()
        
            XCTAssertEqual(urlString1, "https://od-api.oxforddictionaries.com/api/v1/entries/en/love/definitions")
        }
        
        let apiRequest2 = OxfordAPIRequest(withWord: "love", withDictionaryEntryLookupFilter: .pronunciations([]), forRegions: nil, forLanguage: .English)
        
        XCTAssertNotNil(apiRequest2)
        
        if let nonNilRequest2 = apiRequest2{
            
            let urlString2 = nonNilRequest2.getURLString()
        
            XCTAssertEqual(urlString2, "https://od-api.oxforddictionaries.com/api/v1/entries/en/love/pronunciations")
        }
        
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
