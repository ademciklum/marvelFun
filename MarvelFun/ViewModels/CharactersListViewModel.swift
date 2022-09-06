//
//  CharactersListViewModel.swift
//  MarvelFun
//
//  Created by Artem Demchenko on 05.09.2022.
//

import Foundation
import Combine

class CharactersListViewModel: ObservableObject {
    
    @Published var search: String = ""
    @Published var characters = [Character]()
    
    private var charactersNetworkService = CharactersNetworkService()
    
    private lazy var searchCharacterPublisher: AnyPublisher<[Character], Error> = {
        $search
            .debounce(for: 0.5, scheduler: DispatchQueue.global())
            .flatMap { search -> AnyPublisher<[Character], Error> in
                self.charactersNetworkService.charactersPublisher(search)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }()
    
    init() {
        charactersNetworkService.charactersPublisher()
            .replaceError(with: [])
            .assign(to: &$characters)
        
        searchCharacterPublisher
            .replaceError(with: [])
            .assign(to: &$characters)
    }
}
