//
//  OxfordAPIClientTests.swift
//  OxfordAPIClientTests
//
//  Created by Aleksander Makedonski on 1/31/18.
//  Copyright © 2018 Aleksander Makedonski. All rights reserved.
//

import XCTest
@testable import OxfordAPIClient

class OxfordAPIClientTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testQueryParameterStringsForLexicalCategoryFilter(){
        
        let lexicalCategoryFilter = OxfordAPIEndpoint.OxfordAPIFilter.lexicalCategory([
            OxfordLexicalCategory.adjective.rawValue,
            OxfordLexicalCategory.noun.rawValue,
            OxfordLexicalCategory.determiner.rawValue
            ])
        
        
        let queryParamString1 = lexicalCategoryFilter.getQueryParameterString(isLastQueryParameter: true)

        XCTAssertEqual(queryParamString1, "lexicalCategory=adjective,noun,determiner")
        
        let queryParamString2 = lexicalCategoryFilter.getQueryParameterString(isLastQueryParameter: false)
        
        XCTAssertEqual(queryParamString2, "lexicalCategory=adjective,noun,determiner;")
        
        
        
    }
    
    
    func testQueryParameterStringForRegions(){
        
        let regionFilter = OxfordAPIEndpoint.OxfordAPIFilter.regions([
            OxfordRegion.gb.rawValue,
            OxfordRegion.us.rawValue
            ])
        
        let queryParamStr1 = regionFilter.getQueryParameterString(isLastQueryParameter: false)
        
        XCTAssertEqual(queryParamStr1, "regions=gb,us;")
        
        let queryParamStr2 = regionFilter.getQueryParameterString(isLastQueryParameter: true)

        
        XCTAssertEqual(queryParamStr2, "regions=gb,us")

        
    }
    
    
    func testQueryParameterStringForDomains(){
        
        let domainFilter = OxfordAPIEndpoint.OxfordAPIFilter.domains([
            OxfordDomain.anatomy.rawValue,
            OxfordDomain.alcoholic.rawValue
            ])
        
        let queryParamStr1 = domainFilter.getQueryParameterString(isLastQueryParameter: false)
        
        XCTAssertEqual(queryParamStr1, "domains=anatomy,alcoholic;")
        
        let queryParamStr2 = domainFilter.getQueryParameterString(isLastQueryParameter: true)
        
        
        XCTAssertEqual(queryParamStr2, "domains=anatomy,alcoholic")
    }
    
    func testQueryParameterStringForRegisters(){
        
        let registerFilter = OxfordAPIEndpoint.OxfordAPIFilter.registers([
            OxfordLanguageRegister.allusive.rawValue,
            OxfordLanguageRegister.coarse_slang.rawValue
            ])
        
        let queryParamStr1 = registerFilter.getQueryParameterString(isLastQueryParameter: false)
        
        XCTAssertEqual(queryParamStr1, "registers=allusive,coarse_slang;")
        
        let queryParamStr2 = registerFilter.getQueryParameterString(isLastQueryParameter: true)
        
        XCTAssertEqual(queryParamStr2, "registers=allusive,coarse_slang")

        
    }
    
    func testQueryParameterStringsForGrammaticalFeaturesFilter(){
        
        let grammaticalFeaturesFilter = OxfordAPIEndpoint.OxfordAPIFilter.grammaticalFeatures([
            OxfordGrammaticalFeature.abbreviation.rawValue,
            OxfordGrammaticalFeature.attributive.rawValue,
            OxfordGrammaticalFeature.auxiliary.rawValue,
            OxfordGrammaticalFeature.cardinal.rawValue,
            OxfordGrammaticalFeature.collective.rawValue
            ])
        
        
        let queryParamString1 = grammaticalFeaturesFilter.getQueryParameterString(isLastQueryParameter: true)
        
        XCTAssertEqual(queryParamString1, "grammaticalFeatures=abbreviation,attributive,auxiliary,cardinal,collective")
        
        let queryParamString2 = grammaticalFeaturesFilter.getQueryParameterString(isLastQueryParameter: false)
        
        XCTAssertEqual(queryParamString2, "grammaticalFeatures=abbreviation,attributive,auxiliary,cardinal,collective;")
        
        
    }
    
    func testFilterValidationForEntriesEndpoint() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results
        
        let entriesEndpoint = OxfordAPIEndpoint.entries
        
        /** Associated values are not required when filtering a query for dictionary entries **/
        
        let filterByDomains = OxfordAPIEndpoint.OxfordAPIFilter.domains([])
        let filterByDefinitions = OxfordAPIEndpoint.OxfordAPIFilter.definitions([])
        let filterByPronunciations = OxfordAPIEndpoint.OxfordAPIFilter.pronunciations([])
        let filterByExamples = OxfordAPIEndpoint.OxfordAPIFilter.examples([])
        let filterByEtymologies = OxfordAPIEndpoint.OxfordAPIFilter.etymologies([])
        let filterByLexicalCategories = OxfordAPIEndpoint.OxfordAPIFilter.lexicalCategory([])
        let filterByGrammaticalFeatures = OxfordAPIEndpoint.OxfordAPIFilter.grammaticalFeatures([])
        let filterByRegion = OxfordAPIEndpoint.OxfordAPIFilter.regions([])
        let filterByRegisters = OxfordAPIEndpoint.OxfordAPIFilter.registers([])
        let filterByVariantForms = OxfordAPIEndpoint.OxfordAPIFilter.variantForms([])
        
        let filterByCollateItems = OxfordAPIEndpoint.OxfordAPIFilter.collate([])
        let filterByFormat = OxfordAPIEndpoint.OxfordAPIFilter.format(false)
        
        let validFilters = entriesEndpoint.getAvailableFilters()
    
        /** There a total of 10 valid filters for the 'entries' endpoint, where the filter need not have an endpoint specified **/
        
        XCTAssertEqual(validFilters.count, 10)
        
        /** Test that all the filters for the 'entries' endpoints are contained in the set of valid filters returned by the endpoint enum case **/
        
        XCTAssertTrue(
            validFilters.contains(filterByDomains) &&
            validFilters.contains(filterByDefinitions) &&
            validFilters.contains(filterByPronunciations) &&
            validFilters.contains(filterByExamples) &&
            validFilters.contains(filterByEtymologies) &&
            validFilters.contains(filterByLexicalCategories) &&
            validFilters.contains(filterByGrammaticalFeatures) &&
            validFilters.contains(filterByRegion) &&
            validFilters.contains(filterByVariantForms) &&
            validFilters.contains(filterByRegisters)

        )
        
        /** Test that the filters not specific to the 'entries' endpoints are not contained in the set of valid filters returned by the endpoint enum case **/

        
        XCTAssertFalse(
            validFilters.contains(filterByCollateItems) ||
            validFilters.contains(filterByFormat)
        )
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
