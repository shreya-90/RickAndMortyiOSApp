//
//  RMCharacterStatus.swift
//  RickAndMorty
//
//  Created by Shreya Pallan on 07/04/24.
//

import Foundation

enum RMCharacterStatus: String, Codable {
    
   // ('Alive', 'Dead' or 'unknown').
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
}
