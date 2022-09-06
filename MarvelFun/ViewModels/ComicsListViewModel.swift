//
//  ComicsListViewModel.swift
//  MarvelFun
//
//  Created by Artem Demchenko on 06.09.2022.
//

import Foundation
import Combine

class ComicsListViewModel: ObservableObject {
    
    @Published var character: Character
    @Published var sort: Bool = false
    @Published var comics = [Comic]()
    
    private var comicsNetworkService = ComicsNetworkService()
    
    init(_ character: Character) {
        self.character = character
    }
    
    func loadComics() {
        comicsNetworkService.comicsPublisher(character.id)
            .replaceError(with: [])
            .assign(to: &$comics)
    }
}
