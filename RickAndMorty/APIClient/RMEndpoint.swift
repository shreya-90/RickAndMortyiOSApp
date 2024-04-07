//
//  RMEndpoint.swift
//  RickAndMorty
//
//  Created by Shreya Pallan on 07/04/24.
//

import Foundation


/// Represets unique api endpoints
@frozen enum RMEndPoint: String {
    /// Endpoint to get character info
    case character  //"character"
    
    /// Endpoint to get location info
    case location
    
    /// Endpoint to get episode info
    case episode
}
