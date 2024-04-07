//
//  RMCharacterGender.swift
//  RickAndMorty
//
//  Created by Shreya Pallan on 07/04/24.
//

import Foundation


enum RMCharacterGender: String, Codable {
    
    // ('Female', 'Male', 'Genderless' or 'unknown').
    case male = "male"
    case female = "female"
    case genderless = "genderless"
    case unknown = "unknown"
}
