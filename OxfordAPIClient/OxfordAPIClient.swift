//
//  OxfordAPIClient.swift
//  Scrambled Messenger
//
//  Created by Aleksander Makedonski on 12/3/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation

class OxfordAPIClient: OxfordDictionaryAPIDelegate{
    
    static let sharedClient = OxfordAPIClient()
    
    /** Instance variables **/
    
    private var urlSession: URLSession!
    private var delegate: OxfordDictionaryAPIDelegate?
    
    private init(){
        urlSession = URLSession.shared
        delegate = self
    }
    
    enum DictionaryLookupFilter{
        case examples
        case pronunciations
        case definitions
        case etymologies
        case variantForms
        case registers
        case regions
        case domains
        case grammaticalFeatures
        case lexicalCategory
    
        func getOxfordAPIFiler() -> OxfordAPIEndpoint.OxfordAPIFilter{
            
            switch self {
            case .examples:
                return OxfordAPIEndpoint.OxfordAPIFilter.examples([])
            case .pronunciations:
                return OxfordAPIEndpoint.OxfordAPIFilter.pronunciations([])
            case .definitions:
                return OxfordAPIEndpoint.OxfordAPIFilter.definitions([])
            case .etymologies:
                return OxfordAPIEndpoint.OxfordAPIFilter.etymologies([])
            case .variantForms:
                return OxfordAPIEndpoint.OxfordAPIFilter.variantForms([])
            case .registers:
                return OxfordAPIEndpoint.OxfordAPIFilter.registers([])
            case .regions:
                return OxfordAPIEndpoint.OxfordAPIFilter.regions([])
            case .domains:
                return OxfordAPIEndpoint.OxfordAPIFilter.domains([])
            case .grammaticalFeatures:
                return OxfordAPIEndpoint.OxfordAPIFilter.grammaticalFeatures([])
            case .lexicalCategory:
                return OxfordAPIEndpoint.OxfordAPIFilter.lexicalCategory([])
       
            }
        }
        
    }
    
    func setOxfordDictionaryAPIClientDelegate(with apiDelegate: OxfordDictionaryAPIDelegate){
        
        self.delegate = apiDelegate
        
    }
    
    func resetDefaultDelegate(){
        self.delegate = self
    }
    
    
    
   



    func downloadDictionaryEntryJSONData(forWord queryWord: String, andForLanguage language:OxfordAPILanguage){
        
        if let apiRequest = OxfordAPIRequest(withQueryWord: queryWord, forRegions: nil, forLanguage: language, withFilterForDictionaryEntryLookup: nil, withQueryFilters: nil){
            
            let urlRequest = apiRequest.generateURLRequest()
            
            self.startDataTask(withURLRequest: urlRequest)
            
        } else {
            
            print("Unable to instantiate the dictionary api request")
            let error = NSError(domain: "Unable to instantiate the dictionary api request", code: 0, userInfo: nil)
            
            self.delegate?.didFailToConnectToEndpoint(withError: error)
        }

    
       
    }
    
     func downloadFilteredDictionaryEntryJSONData(forWord word: String, andForEntryFilter entryFilter: DictionaryLookupFilter){
        
        let apiFilter = entryFilter.getOxfordAPIFiler()
        
        downloadDictionaryEntryJSONData(forWord: word, andForEntryFilter: apiFilter)
    }

    
    
    private func downloadDictionaryEntryJSONData(forWord word: String, andForEntryFilter entryFilter: OxfordAPIEndpoint.OxfordAPIFilter){
        
        if let apiRequest = OxfordAPIRequest(withWord: word, withDictionaryEntryFilter: entryFilter){
            
            let urlRequest = apiRequest.generateURLRequest()
            
            self.startDataTask(withURLRequest: urlRequest)
            
        } else {
            
            print("Unable to instantiate the dictionary api request")
            let error = NSError(domain: "Unable to instantiate the dictionary api request", code: 0, userInfo: nil)
            
            self.delegate?.didFailToConnectToEndpoint(withError: error)
        }
        
       
    }
    
    func downloadExampleSentencesJSONData(forWord word: String){
        
        let apiRequest = OxfordSentencesAPIRequest(withQueryWord: word)
        
        print("The url string for this request is: \(apiRequest.getURLString())")
        
        let urlRequest = apiRequest.generateURLRequest()
        
        self.startDataTask(withURLRequest: urlRequest)
    }
    
    func downloadAPIUtilityRequestJSONData(forRESTEndpoint endpoint: OxfordUtilityAPIRequest.UtiltyRequestEndpoint, andWithTargetLanguage targetLanguage: OxfordAPILanguage?, andWithEndpointForAllFiltersRequest endpointForAllFiltersRequest: OxfordAPIEndpoint){
        
        let apiRequest = OxfordUtilityAPIRequest(withUtilityRequestEndpoint: endpoint, andWithTargetLanguage: targetLanguage, andWithEndpointForAllFiltersRequest: endpointForAllFiltersRequest)
        
        print("The url string generated from this request is: \(apiRequest.getURLString())")
        
        let urlRequest = apiRequest.generateURLRequest()
        
        self.startDataTask(withURLRequest: urlRequest)
    }
    
    func downloadThesaurusJSONData(forWord word: String, withAntonyms isAntonymRequest: Bool, withSynonyms isSynonymRequest: Bool){
        
        let apiRequest = OxfordThesaurusAPIRequest(withWord: word, isAntonymRequest: isAntonymRequest, isSynonymRequest: isSynonymRequest)
        
        print("The url string generated from this api request is: \(apiRequest.getURLString())")
        
        let urlRequest = apiRequest.generateURLRequest()
        
        self.startDataTask(withURLRequest: urlRequest)
    }
    
    
    
    
   
      
    
    
    
    /** Wrapper function for executing aynchronous download of JSON data from Oxford Dictionary API **/
    
    private func startDataTask(withURLRequest request: URLRequest){
        
        guard let delegate = self.delegate else {
            fatalError("Error: no delegate specified for Oxford API download task")
        }
        
        _ = self.urlSession.dataTask(with: request, completionHandler: { data, response, error in
            
            switch (data,response,error){
            case (.some,.some,.none),(.some,.some,.some): //Able to connect to the server, data received
                
                let httpResponse = (response! as! HTTPURLResponse)
                
                
                if let jsonResponse = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! JSONResponse{
                    //Data received, and JSON serialization successful
                    
                    delegate.didFinishReceivingJSONData(withJSONResponse: jsonResponse, withHTTPResponse: httpResponse)
                    
                } else{
                    //Data received, but JSON serialization not successful
                    delegate.didFailToGetJSONData(withHTTPResponse: httpResponse)
                }
                
                break
            case (.none,.some,.none),(.none,.some,.some): //Able to connect to the server but failed to get data or received a bad HTTP Response
                if let httpResponse = (response as? HTTPURLResponse){
                    delegate.didFailToGetJSONData(withHTTPResponse: httpResponse)
                }
                break
            case (.none,.none,.some): //Unable to connect to the server, with an error received
                delegate.didFailToConnectToEndpoint(withError: error!)
                break
            case (.none,.none,.none): //Unable to connect to the server, no error received
                let error = NSError(domain: "Failed to get a response: Error occurred while attempting to connect to the server", code: 0, userInfo: nil)
                delegate.didFailToConnectToEndpoint(withError: error)
                break
            default:
                break
            }
            
        }).resume()
    }
    
}



//MARK: ********* Conformance to DictionaryAPIClient protocol methods

extension OxfordAPIClient{
    
    /** Unable to establish a connection with the server **/
    
    internal func didFailToConnectToEndpoint(withError error: Error) {
        
        print("Error occurred while attempting to connect to the server: \(error.localizedDescription)")
        
        
    }
    
    /** Proper credentials are provided, the API request can be authenticated; an HTTP Response is received but no data is provided **/
    
    
    internal func didFailToGetJSONData(withHTTPResponse httpResponse: HTTPURLResponse){
        print("Unable to get JSON data with http status code: \(httpResponse.statusCode)")
        showOxfordStatusCodeMessage(forHTTPResponse: httpResponse)
        
        
        
    }
    
    /** Proper credentials are provided, and the API request is fully authenticated; an HTTP Response is received and the data is provided by the raw data could not be parsed into a JSON object **/
    
    internal func didFailToSerializeJSONData(withHTTPResponse httpResponse: HTTPURLResponse){
        
        print("Unable to serialize the data into a json response, http status code: \(httpResponse.statusCode)")
        showOxfordStatusCodeMessage(forHTTPResponse: httpResponse)
        
    }
    
    
    
    /** If erroneous credentials are provided, the API request can't be authenticated; an HTTP Response is received but no data is provided **/
    
    internal func didFinishReceivingHTTPResponse(withHTTPResponse httpResponse: HTTPURLResponse){
        
        print("HTTP response received with status code: \(httpResponse.statusCode)")
        showOxfordStatusCodeMessage(forHTTPResponse: httpResponse)
    }
    
    /** Proper credentials are provided, and the API request is fully authenticated; an HTTP Response is received and serialized JSON data is provided **/
    
    internal func didFinishReceivingJSONData(withJSONResponse jsonResponse: JSONResponse, withHTTPResponse httpResponse: HTTPURLResponse) {
        
        print("JSON response received, http status code: \(httpResponse.statusCode)")
        showOxfordStatusCodeMessage(forHTTPResponse: httpResponse)
        
        
        print("JSON data received as follows:")
        print(jsonResponse)
    }
    
    func showOxfordStatusCodeMessage(forHTTPResponse httpResponse: HTTPURLResponse){
        
        if let oxfordStatusCode = OxfordHTTPStatusCode(rawValue: httpResponse.statusCode){
            let statusCodeMessage = oxfordStatusCode.statusCodeMessage()
            print("Status Code Message: \(statusCodeMessage)")
        }
        
        
    }
}
