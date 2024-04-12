//
//  RMCharacterGender.swift
//  RickAndMorty
//
//  Created by Shreya Pallan on 07/04/24.
//

import Foundation


enum RMCharacterGender: String, Codable {
    
    // ('Female', 'Male', 'Genderless' or 'unknown').
    case male = "Male"
    case female = "Female"
    case genderless = "Genderless"
    case unknown = "unknown"
}
