//
//  RMGetAllCharactersResponse.swift
//  RickAndMorty
//
//  Created by Shreya Pallan on 11/04/24.
//

import Foundation

struct RMGetAllCharactersResponse: Codable {

    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
    
    let info: Info
    let results: [RMCharacter]
}

