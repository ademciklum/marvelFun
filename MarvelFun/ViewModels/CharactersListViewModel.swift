//
//  CharactersListViewModel.swift
//  MarvelFun
//
//  Created by Artem Demchenko on 05.09.2022.
//

import Foundation
import Combine

class CharactersListViewModel: ObservableObject, CharactersViewModelProtocol, ErrorPublishedProtocol {
    
    @Published var search: String
    @Published var lastError: RequestError?
    @Published var characters: [Character]
    
    private let dataStorage: DataStorageProtocol
    private var charactersNetworkService = CharactersNetworkService()
    private var cancellables: Set<AnyCancellable> = []
    
    private lazy var searchCharacterPublisher: AnyPublisher<[Character], Error> = {
        $search
            .drop(while: { $0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty })
            .delay(for: 0.5, scheduler: DispatchQueue.global())
            .debounce(for: 0.5, scheduler: DispatchQueue.global())
            .flatMap { search -> AnyPublisher<[Character], Error> in
                self.charactersNetworkService.charactersPublisher(search)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }()
    
    init(dataStorage: DataStorageProtocol, networkService: ComicsNetworkServiceProtocol = ComicsNetworkService()) {
        self.search = ""
        self.dataStorage = dataStorage
        self.characters = dataStorage.load() ?? []
        loadCharacters()
        loadSearch()
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
    
    func saveCharacters() {
        dataStorage.save(characters)
    }
    
    func reloadData() {
        search = ""
        loadCharacters()
        loadSearch()
    }
}

protocol CharactersViewModelProtocol {
    var search: String { get set }
    var characters: [Character] { get }
    
    func loadCharacters()
    func loadSearch()
    func saveCharacters()
    func reloadData()
}

protocol ErrorPublishedProtocol {
    var lastError: RequestError? { get }
}
