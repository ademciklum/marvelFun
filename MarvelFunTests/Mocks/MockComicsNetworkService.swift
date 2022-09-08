//
//  MockComicsNetworkService.swift
//  MarvelFunTests
//
//  Created by Artem Demchenko on 07.09.2022.
//

import Foundation
import Combine

@testable import MarvelFun

struct MockComicsNetworkService: ComicsNetworkServiceProtocol {
    let jsonName: String
    
    func comicsPublisher(_ characterId: Int, offset: Int = 0, limit: Int = 20) -> AnyPublisher<[Comic], Error> {
        let jsonDataPublisher = Future<Data?, Error> { $0(.success(jsonData)) }
            .compactMap { $0 }
            .eraseToAnyPublisher()
        
        return DataTaskPublisher.publisherWithData(jsonDataPublisher)
            .decode(type: [Comic].self, decoder: ComicJSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    var jsonData: Data? {
        guard let url = Bundle.unitTestsBundle?.url(forResource: jsonName, withExtension: "json") else {
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            return data
        } catch let error {
            print("Error reading data \(error)")
            return nil
        }
    }
}

private extension Bundle {
    class var unitTestsBundle: Bundle? {
        return Bundle(identifier: "home.MarvelFunTests")
    }
}
