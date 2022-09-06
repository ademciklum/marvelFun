//
//  CharactersNetworkService.swift
//  MarvelFun
//
//  Created by Artem Demchenko on 04.09.2022.
//

import Foundation
import Combine

struct CharactersNetworkService {
    
    func charactersPublisher(_ nameStartsWith: String? = nil, offset: Int = 0, limit: Int = 20) -> AnyPublisher<[Character], Error> {
        var query = [String: String]()
        if let nameStartsWith = nameStartsWith,
            nameStartsWith.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false {
            query["nameStartsWith"] = nameStartsWith
        }
        let request = URLRequestComposer.compose(request: .characters, queryParameters: query)
        return DataTaskPublisher.publisherForRequest(request)
            .compactMap { $0 }
            .decode(type: [Character].self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
