//
//  ComicsNetworkService.swift
//  MarvelFun
//
//  Created by Artem Demchenko on 06.09.2022.
//

import Foundation
import Combine

struct ComicsNetworkService {
    
    func comicsPublisher(_ characterId: Int, offset: Int = 0, limit: Int = 20) -> AnyPublisher<[Comic], Error> {
        let request = URLRequestComposer.compose(request: .characterComics(characterId))
        return DataTaskPublisher.publisherForRequest(request)
            .compactMap { $0 }
            .decode(type: [Comic].self, decoder: ComicJSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
