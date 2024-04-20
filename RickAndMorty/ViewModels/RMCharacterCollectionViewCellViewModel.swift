//
//  RMCharacterCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Shreya Pallan on 12/04/24.
//

import Foundation


struct RMCharacterCollectionViewCellViewModel: Hashable, Equatable{
    
    let characterName: String
    private let characterStatus: RMCharacterStatus
    private let characterImageURL: URL?
    
    
    static func == (lhs: RMCharacterCollectionViewCellViewModel, rhs: RMCharacterCollectionViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(characterName)
        hasher.combine(characterStatus)
        hasher.combine(characterImageURL)
    }
    
    //MARK: - Init
    
    init(
        characterName: String,
        characterStatus: RMCharacterStatus,
        characterImageURL: URL?) {
            self.characterName = characterName
            self.characterStatus = characterStatus
            self.characterImageURL = characterImageURL
        }
    
    
    public var characterStatusText: String {
        return "Status: \(characterStatus.text)"
    }
    
    
    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
       // TODO: Abstract to ImageManager
        
        guard let url = self.characterImageURL else {
            completion(.failure(URLError(.badURL)))
            return
        }
        RMImageLoader.shared.downloadImage(url, completion: completion)
    }
}
