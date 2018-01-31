//
//  OxfordAPIRequest.swift
//  Scrambled Messenger
//
//  Created by Aleksander Makedonski on 12/3/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation



class OxfordAPIRequest{
    
    //Static constants
    
     static let baseURLString = "https://od-api.oxforddictionaries.com/api/v1/"
     private static let appID = "abkdfe"
     private static let appKey = "32343adfad6f9739d4974ere81168976b6e991b"
    
    
    //Computed Properties
    
    private static var baseURL: URL{
        return URL(string: baseURLString)!
    }
    
    var baseURLString: String{
        return OxfordAPIRequest.baseURLString
    }
    
    
    //Properties that must be intialized
    
     var endpoint: OxfordAPIEndpoint
     var word: String
     var language: OxfordAPILanguage
    
    
    //Optional properites
    
     var filterForDictionaryEntriesLookup: OxfordAPIEndpoint.OxfordAPIFilter?
     var queryFilters: [OxfordAPIEndpoint.OxfordAPIFilter]?
     var regions: [OxfordRegion]?
    
    //Properties with default values
    
    var resultLimit = 5000
    var resultOffset = 0
 
   
    
    /** This initializer allows the user to specify the language and region without specifying other optional query parameters **/
    
    convenience init?(withWord queryWord: String, withDictionaryEntryLookupFilter dictEntryLookupFilter: OxfordAPIEndpoint.OxfordAPIFilter,forRegions regions: [OxfordRegion]?, forLanguage queryLanguage: OxfordAPILanguage){
        
        self.init(withQueryWord: queryWord, forRegions: regions, forLanguage: queryLanguage, withFilterForDictionaryEntryLookup: dictEntryLookupFilter, withQueryFilters: nil)
    
        
       
    }
    
    /** This convenience initializer only uses a dictionary entry lookup filter to filter the returned JSON data; it avoids using other query filter parameters in order to provide a more user-friendly initializer **/
    
    convenience init?(withWord queryWord: String, withDictionaryEntryFilter dictionaryEntryLookupFilter: OxfordAPIEndpoint.OxfordAPIFilter){
        
        self.init(withQueryWord: queryWord, forRegions: nil, forLanguage: .English, withFilterForDictionaryEntryLookup: dictionaryEntryLookupFilter, withQueryFilters: nil)
      
    
    }
    
    /** A default initializer is provided as convenience initializer **/
    
    convenience init(){
        
        let randomWords = ["Love","Justice","Friendship","Big","Expensive"]
        let randomIdx = Int(arc4random_uniform(UInt32(randomWords.count)))
        let randomWord = randomWords[randomIdx]
        
        /** Since we know that definitions is a valid dictionary entry lookup filter, we force unwrap this initializer **/
        
        self.init(withQueryWord: randomWord, forRegions: nil, forLanguage: .English, withFilterForDictionaryEntryLookup: .definitions([]), withQueryFilters: nil)!
        
    
    }
    

    
    /** Designated Initializer  **/
    
    init?(withQueryWord queryWord: String,forRegions qRegions: [OxfordRegion]?, forLanguage qLanguage: OxfordAPILanguage, withFilterForDictionaryEntryLookup qFilterForDictionaryEntryLookup: OxfordAPIEndpoint.OxfordAPIFilter?, withQueryFilters qFilters: [OxfordAPIEndpoint.OxfordAPIFilter]?){
        
        if let qFilterForDictionaryEntryLookup = qFilterForDictionaryEntryLookup{
            
            if !OxfordAPIRequest.isValidDictionaryEntryLookUpFilter(filter: qFilterForDictionaryEntryLookup){
                return nil
            }
        }
       
        
        self.endpoint = OxfordAPIEndpoint.entries
        self.word = queryWord
        self.regions = qRegions
        self.language = qLanguage
        self.filterForDictionaryEntriesLookup = qFilterForDictionaryEntryLookup
        self.queryFilters = qFilters
    }
    
  
    
    
    //TODO: Compare the efficiency and speed of the two URLRequest generators - one that requires validation and the other that doesn't require it
    
    func generateValidatedURLRequest() throws -> URLRequest{
        
       
        guard OxfordAPIRequest.hasValidFilters(filters: self.queryFilters, forEndpoint: self.endpoint) else {
            
            throw NSError(domain: "OxfordAPIClientErrorDomain", code: 0, userInfo: nil)
            
        }
        
        let urlString = getURLString()
        
        let url = URL(string: urlString)!
        
        return getURLRequest(forURL: url)
    }
    
    func generateURLRequest() -> URLRequest{
        
        let urlString = getURLString()
        
        let url = URL(string: urlString)!
        
        return getURLRequest(forURL: url)
    }
    
    private func getURLRequest(forURL url: URL) -> URLRequest{
        
        var request = URLRequest(url: url)
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(OxfordAPIRequest.appID, forHTTPHeaderField: "app_id")
        request.addValue(OxfordAPIRequest.appKey, forHTTPHeaderField: "app_key")
        
        return request
    }
    
    
    private static func isValidDictionaryEntryLookUpFilter(filter: OxfordAPIEndpoint.OxfordAPIFilter) -> Bool{
        
        let validFilters = OxfordAPIEndpoint.entries.getAvailableFilters()
        
        return validFilters.contains(filter)
    }
 
    
    private static func hasValidFilters(filters: [OxfordAPIEndpoint.OxfordAPIFilter]?,forEndpoint endpoint: OxfordAPIEndpoint) -> Bool {
        
        if(filters == nil || (filters != nil && filters!.isEmpty)){
            return true
        }
        
        let toCheckFilters = filters!
        
        let allowableFilterSet = endpoint.getAvailableFilters()

        print("Checking if the filters passed in are allowable")
        
        for filter in toCheckFilters{
            print("Testing the filter: \(filter.getDebugName())")
            if !allowableFilterSet.contains(filter){
                print("The allowable filters don't contain: \(filter.getDebugName())")
                return false
            }
        }
        
        return true
        
        
    }
    
  


   
    /** The default implementation for the APIRequest base class makes a request to the Oxford Dictionary API without specifying any query parameters **/
    
     func getURLString() -> String{
        
        
        var nextURLStr = OxfordAPIRequest.baseURLString
        
        nextURLStr = getURLStringFromAppendingEndpointSpecifier(relativeToURLString: nextURLStr)
        
        nextURLStr = getURLStringFromAppendingLanguageSpecifier(relativeToURLString: nextURLStr)
        
        nextURLStr = getURLStringFromAppendingQueryWord(relativeToURLString: nextURLStr)
        
        
    
        if let filterForDictEntryLookup = self.filterForDictionaryEntriesLookup?.getDebugName(){
            
            return nextURLStr.appending("\(filterForDictEntryLookup)")
            
        } else if let regions = self.regions{
            
            let regionStringArray = regions.map({$0.rawValue})
            
            var regionStr = regionStringArray.reduce("", { $0.appending("\($1),")})
            
            regionStr.removeLast()
            
            nextURLStr = nextURLStr.appending(regionStr)
            
            return nextURLStr
        } else {
            
            nextURLStr.removeLast()
        }
        
    
        return nextURLStr


    }
        
    
    
    
    //MARK: ******** Helper Methods for Building API Request URL String
    
     func addFilters(filters: [OxfordAPIEndpoint.OxfordAPIFilter], toURLString urlString: inout String){

        
        if(filters.isEmpty || filters.count <= 0){
            return
        }
        
        filters.forEach({
        
            let filterString = $0.getQueryParameterString(isLastQueryParameter: false)
            urlString = urlString.appending(filterString)
        })
        
        
        if let lastChar = urlString.last, lastChar == ";"{
            urlString.removeLast()
        }
       
        
    }
    
     //MARK: ********* Helper Methods - The methods below modify strings passed in as inout parameters rather returning modified copies
    

    
    func appendStringArrayElementsToURLString(forQueryParameter queryParameter: String, forParameterValues parameterValues: [String],toCurrentURLString urlString: inout String){
        
        
        var queryString = "\(queryParameter)="
            
        var paramValueStr = parameterValues.reduce(String(), { $0.appending("\($1),")})
        paramValueStr.removeLast()
        paramValueStr.append(";")
        
        queryString.append(paramValueStr)
        
        urlString = urlString.appending(queryString)
    }
    
    
    
    
    func appendStringToURLString(forQueryParameter queryParameter: String, usingParameterValue parameterValue: String,toCurrentURLString urlString: inout String){
        
        
        let concatenatedString = "\(queryParameter)=\(parameterValue);"
       
        urlString = urlString.appending(concatenatedString)
    }
    
    
    func appendBooleanToURLString(forQueryParameter queryParameter: String, usingParameterValue parameterValue: Bool,toCurrentURLString urlString: inout String){
        
        
        let parameterValString = parameterValue ? "true" : "false";
        
        let concatenatedString = "\(queryParameter)=\(parameterValString);"
        
        urlString = urlString.appending(concatenatedString)
    }
    
    //MARK: ********* Helper Methods - Return values for the string-building methods are string that have been copied and modified
    
     func getURLStringFromAppendingQueryWord(relativeToURLString urlString: String) -> String{
        
        let encodedQueryWord = getEncodedQueryWord()
        
        return urlString.appending("\(encodedQueryWord)/")

        
    }
    
    func getURLStringFromAppendingLanguageSpecifier(relativeToURLString urlString: String) -> String{
        
        
        return urlString.appending("\(self.language.rawValue)/")
    }
    
     func getURLStringFromAppendingEndpointSpecifier(relativeToURLString urlString: String) -> String{
        
        
        return urlString.appending("\(self.endpoint.rawValue)/")
        
    }
    
    
    
   
    
    //MARK: ****** Helper Function for Encoding Query Parameters
    
    private func getEncodedQueryWord() -> String{
        
        //Declare mutable, local version of word parameter
        return getEncodedString(fromRawString: self.word)
    }
    
    private func getEncodedString(fromRawString rawString: String) -> String{
        
        //Declare mutable, local version of string parameter
        var copiedString = rawString
        
        //Make the string lowercased
        copiedString = copiedString.lowercased()
        
        //Add percent encoding to the query parameter
        let percentEncoded_string = copiedString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        copiedString = percentEncoded_string == nil ? copiedString : percentEncoded_string!
        
        //Replace spaces with underscores
        copiedString = copiedString.replacingOccurrences(of: " ", with: "_")
        
        return copiedString
    }


    
}


