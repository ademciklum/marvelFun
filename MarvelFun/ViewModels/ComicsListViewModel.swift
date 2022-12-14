//
//  ComicsListViewModel.swift
//  MarvelFun
//
//  Created by Artem Demchenko on 06.09.2022.
//

import Foundation
import Combine

class ComicsListViewModel: ObservableObject, ComicsListViewModelProtocol, ErrorPublishedProtocol {
    
    @Published var character: CharacterIdentifiable
    @Published var comics = [Comic]()
    @Published var lastError: RequestError?
    
    private var comicsNetworkService: ComicsNetworkServiceProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    init(_ character: CharacterIdentifiable,
         networkService: ComicsNetworkServiceProtocol = ComicsNetworkService()) {
        self.character = character
        self.comicsNetworkService = networkService
    }
    
    func loadComics() {
        comicsNetworkService.comicsPublisher(character.id, offset: 0, limit: 20)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.lastError = RequestError.defaultError(error: error)
                case .finished:
                    break
                }
            } receiveValue: { result in
                self.comics = result
                self.lastError = nil
            }.store(in: &cancellables)
    }
}

protocol ComicsListViewModelProtocol {
    var character: CharacterIdentifiable { get }
    var comics: [Comic] { get }
    
    func loadComics()
}
