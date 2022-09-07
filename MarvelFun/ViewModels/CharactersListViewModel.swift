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
    @Published var lastError: RequestError?
    @Published var characters: [Character] = DataStorage().load() ?? []
    
    private var charactersNetworkService = CharactersNetworkService()
    private var cancellables: Set<AnyCancellable> = []
    
    private lazy var searchCharacterPublisher: AnyPublisher<[Character], Error> = {
        $search
            .drop(while: { $0.isEmpty })
            .delay(for: 0.5, scheduler: DispatchQueue.global())
            .debounce(for: 0.5, scheduler: DispatchQueue.global())
            .flatMap { search -> AnyPublisher<[Character], Error> in
                self.charactersNetworkService.charactersPublisher(search)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }()
    
    init() {
        reloadData()
    }
    
    func loadCharacters() {
        charactersNetworkService.charactersPublisher()
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.lastError = RequestError.defaultError(error: error)
                case .finished:
                    break
                }
            } receiveValue: { result in
                self.characters = result
                self.lastError = nil
            }.store(in: &cancellables)
    }
    
    func loadSearch() {
        searchCharacterPublisher
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.lastError = RequestError.searchError(error: error)
                case .finished:
                    break
                }
            } receiveValue: { result in
                self.characters = result
                self.lastError = nil
            }.store(in: &cancellables)
    }
    
    func reloadData() {
        search = ""
        loadCharacters()
        loadSearch()
    }
}
