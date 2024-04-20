//
//  RMCharacterDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Shreya Pallan on 13/04/24.
//

import Foundation


/// Controller to show nfo about single charcater
final class RMCharacterDetailViewViewModel {
    
    private let character: RMCharacter
    
    init(character: RMCharacter) {
        self.character = character
    }
    
    public var title: String {
        return character.name.uppercased()
    }
    
    
}
