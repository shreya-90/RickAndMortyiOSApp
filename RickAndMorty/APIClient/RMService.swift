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
    

    enum RMServiceError: Error {
        case failedToCreateRequest
        case failedToGetData
    }
    
    /// Send Rick and Morty API call
    /// - Parameters:
    ///   - request: Request instance
    ///   - type: The type of object we expect to get back
    ///   - completion: Callback with data or error
    public func execute<T:Codable>(
        _ request: RMRequest,
        expecting type: T.Type,
        completion: @escaping (Result<T,Error>) -> Void) {
           
            guard let urlRequest = self.request(from: request) else {
                completion(.failure(RMServiceError.failedToCreateRequest))
                return
            }
            
            let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                guard let data = data, error == nil else {
                    completion(.failure(RMServiceError.failedToGetData))
                    return
                }
                
                //Decode Response
                do {
                    let result = try JSONDecoder().decode(type.self, from: data)
                    completion(.success(result))
                    print(String(describing: result))
                    
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
    }
    
    //MARK:- Private
    
    private func request(from rmRequest: RMRequest) -> URLRequest? {
        guard let url = rmRequest.url else { return nil}
        
        var request = URLRequest(url: url)
        request.httpMethod = rmRequest.httpMethod
        return request
    }
    
    
}
