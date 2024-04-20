//
//  RMRequest.swift
//  RickAndMorty
//
//  Created by Shreya Pallan on 07/04/24.
//

import Foundation



/// Object that Represents a single API call
final class RMRequest {
    
    // base url
    //endpoint
    //path components
    //Query Params
    
    //https://rickandmortyapi.com/api/location/3
    
    private struct Constants {
        static let baseUrl = "https://rickandmortyapi.com/api"
    }
    
    
    /// Desired endpoint
    private let endpoint: RMEndPoint?
    
    
    /// Path components in API, if Any
    private let pathComponents: [String]
    
    
    /// Query arguments in API, if Any
    private let queryParameters: [URLQueryItem]
    
    
    /// Constructed url for the api request in the string format
    private var urlString: String {
        var string = Constants.baseUrl
        string += "/"
        string += endpoint!.rawValue
        
        if !pathComponents.isEmpty {
            pathComponents.forEach {
                string += "/\($0)"
            }
        }
        
        if !queryParameters.isEmpty {
           string += "?"
            let argumentString = queryParameters.compactMap ({
                guard let value = $0.value else { return nil }
                return "\($0.name)=\(value)"
                        
            }).joined(separator: "&")
            string += argumentString
        }
        return string
    }
    
    
    /// Computed and constructed URL
    public var url: URL? {
        return URL(string: urlString)
    }
    
   //MARK - Public
    
    /// Desired HTTP method
    public let httpMethod = "GET"
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - endpoint: Target endpoint
    ///   - pathComponents: Collec tion of Path components
    ///   - queryParameters: Collection of query components
    public init(endpoint: RMEndPoint?,
                pathComponents: [String] = [],
                queryParameters: [URLQueryItem] = []) {
        self.endpoint = endpoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
    }
    
    convenience init?(url: URL) {
        self.init(endpoint: nil)
        let string = url.absoluteString
        if !string.contains(Constants.baseUrl) {
            return nil
        }
        
        let trimmed = string.replacingOccurrences(of: Constants.baseUrl+"/", with: "")
        if trimmed.contains("/") {
            //baseURl/cahracters/abc, we wnat characters
            let components = trimmed.components(separatedBy: "/")
            
            if !components.isEmpty {
                guard let endpointString = components.first else { return }
                if let rmEndpoint = RMEndPoint(rawValue: endpointString) {
                    self.init(endpoint: rmEndpoint)
                    return
                }
            }
            
        } else if trimmed.contains("?") {
            
            let components = trimmed.components(separatedBy: "?")
            
            if !components.isEmpty, components.count >= 2 {
               let endpointString = components[0]
                let queryItemsString = components[1]
                
                //value=name&value=name
                let queryItems: [URLQueryItem] = queryItemsString.components(separatedBy: "&").compactMap({
                    
                    guard $0.contains("=") else {
                        return nil
                    }
                    
                    let parts = $0.components(separatedBy: "=")
                    return URLQueryItem(name: parts[0], value: parts[1])
                })
                
                
                if let rmEndpoint = RMEndPoint(rawValue: endpointString) {
                    self.init(endpoint: rmEndpoint,queryParameters: queryItems)
                    return
                }
            }
            
        }
        return nil
         
        
    }
    
    
}


extension RMRequest {
    
    /// <#Description#>
    static let listCharactersRequest = RMRequest(endpoint: .character)
    
    
    
}
