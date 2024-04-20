//
//  CharacterListViewViewModel.swift
//  RickAndMorty
//
//  Created by Shreya Pallan on 12/04/24.
//

import Foundation
import UIKit

protocol RMCharacterListViewViewModelDelegate: AnyObject {
    func didLoadInitialCharacters()
    func didLoadMoreCharacters(with newIndexPaths: [IndexPath])

    func didSelectCharacter(character: RMCharacter)
}


final class RMCharacterListViewViewModel: NSObject {
    
    public weak var delegate: RMCharacterListViewViewModelDelegate?
    
    private var isLoadingMoreCharacters = false
    
    private var characters: [RMCharacter] = [] {
        didSet {
            print("Creating View Models")
            for character in characters {
                let viewModel = RMCharacterCollectionViewCellViewModel(
                    characterName: character.name, characterStatus: character.status,
                    characterImageURL: URL(string: character.image)
                )
                
                if !cellViewModels.contains(viewModel) {
                    cellViewModels.append(viewModel)
                }
            }
        }
    }
    
    private var cellViewModels: [RMCharacterCollectionViewCellViewModel] = []
    private var apiInfo: RMGetAllCharactersResponse.Info? = nil
    
    public var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }
    
    
    /// Paginate if additional characters are needed
    public func fetchAdditionalCharacters(url: URL) {
//        print(url.absoluteString)
//        print(isLoadingMoreCharacters)
        
        guard !isLoadingMoreCharacters else {
            return
        }
        
        isLoadingMoreCharacters = true
        print("Fetching more characters")
        
        //Fetch Characters
        guard let request = RMRequest(url: url) else {
            isLoadingMoreCharacters = false
            print("Failed to create request")
            return
        }

        RMService.shared.execute(request,
                                 expecting: RMGetAllCharactersResponse.self) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let responseModel):
                
                print("Pre-update: \(self.cellViewModels.count)")
                let moreResults = responseModel.results
                self.apiInfo = responseModel.info
                
                let originalCount = self.characters.count
                let newcount = moreResults.count
                let total = originalCount + newcount
                
                let startingIndex = total - newcount
                
                let indexPathsToAdd: [IndexPath] = Array(startingIndex..<(startingIndex+newcount)).compactMap {
                    return IndexPath(row: $0, section: 0)
                }
                
                print(indexPathsToAdd.count)
                
                self.characters.append(contentsOf: moreResults)
                print("Post-update: \(self.cellViewModels.count)")
                DispatchQueue.main.async {
                    
                    self.delegate?.didLoadMoreCharacters(
                        with: indexPathsToAdd
                    )
                    self.isLoadingMoreCharacters = false
                    

                }
               
            case .failure(let failure):
                print(String(describing: failure))
                self.isLoadingMoreCharacters = false
            }
        }
    }
    
    /// Fetch initial set of charcaters (20)
    public func fetchCharacters() {
        print("Fetching initial characters")
        RMService.shared.execute(.listCharactersRequest,
                                 expecting: RMGetAllCharactersResponse.self) { [weak self] result in
            switch result {
                
            case .success(let responseModel):
                let results = responseModel.results
                self?.apiInfo = responseModel.info
                
                self?.characters.append(contentsOf: results)
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialCharacters()
                }
//                print("Total: "+String(responseModel.info.count))
//                print("Page Result Count: "+String(responseModel.results.count))
//                print("URL: "+String(responseModel.results.first?.image ?? "No image"))
                
            case .failure(let error):
                print(String(describing: error))
            }
        }
        
    }
    
    
}

// MARK: - CollectionView

extension RMCharacterListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier, for: indexPath) as? RMCharacterCollectionViewCell else {
            fatalError("Unsupported Cell")
        }

        let viewModel = cellViewModels[indexPath.row]
        cell.configure(with: viewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let bounds = UIScreen.main.bounds
        let width = (bounds.width-30)/2
        
        return CGSize(
        width: width,
        height: width * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let character = characters[indexPath.row]
        delegate?.didSelectCharacter(character: character)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
                
       guard kind == UICollectionView.elementKindSectionFooter,
       let footer  = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                    withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier,
                                                                    for: indexPath) as? RMFooterLoadingCollectionReusableView else { fatalError("Unsupported") }
        footer.startAnimating()
        return footer
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard shouldShowLoadMoreIndicator else  {
            return .zero
        }
        return CGSize(width: collectionView.frame.width, height: 100.0)
    }
    
}
 
//MARK: - ScrollView
extension RMCharacterListViewViewModel: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard shouldShowLoadMoreIndicator, 
                !isLoadingMoreCharacters,
                !cellViewModels.isEmpty,
                let nextURLString = apiInfo?.next,
                let url = URL(string: nextURLString) else {
                    return
                }
        
                
        
//        print("Offset: \(offset)")
//        print("TotalContentHeight: \(totalContentHeight)")
//        print("totalScrollViewFixedheight: \(totalScrollViewFixedheight)")
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] t in
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedheight = scrollView.frame.size.height
            
            if offset >= (totalContentHeight - totalScrollViewFixedheight - 120) {
                //print("Should start fetching mode")
            
                self?.fetchAdditionalCharacters(url: url)
                //isLoadingMoreCharacters = true
            }
            
            t.invalidate()
        }
            
        
    }
    
    
}
