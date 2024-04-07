//
//  RMService.swift
//  RickAndMorty
//
//  Created by Shreya Pallan on 07/04/24.
//

import Foundation


/// Primary aPI service object to get Rick and Morty data
final class RMService {
    
    
    ///  Shared singleton data
    static let shared = RMService()
    
    
    /// Privitised constructor
    private init() {}
    

    
    /// Send Rick and Morty API call
    /// - Parameters:
    ///   - request: Request instance
    ///   - type: The type of object we expect to get back
    ///   - completion: Callback with data or error
    public func execute<T:Codable>(
        _ request: RMRequest,
        expecting type: T.Type,
        completion: @escaping (Result<T,Error>) -> Void) {
        
    }
}
