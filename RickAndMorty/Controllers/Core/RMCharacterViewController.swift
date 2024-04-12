//
//  RMCharacterViewController.swift
//  RickAndMorty
//
//  Created by Shreya Pallan on 07/04/24.
//

import UIKit

final class RMCharacterViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .systemBackground
        title = "Characters"
        
        RMService.shared.execute(.listCharactersRequest,
                                 expecting: RMGetAllCharactersResponse.self) { result in
            
            switch result {
                
            case .success(let model):
                print("@@@@@@@")
                print("Total: "+String(model.info.count))
                print("Page Result Count: "+String(model.results.count))
                
            case .failure(let error):
                print(String(describing: error))
            }
        }
        
    }
    
}
