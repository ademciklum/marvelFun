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
        return Just(json)
            .compactMap { $0 }
            .tryMap({ data in
                guard let responseObject = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                      let dataDict = responseObject["data"] as? [String: Any],
                      let resultsDict = dataDict["results"] as? [Any],
                      let resultsData = try? JSONSerialization.data(withJSONObject: resultsDict) else {
                    throw NSError(domain: "Parse error", code: NSURLErrorCannotParseResponse)
                }
                return resultsData
            })
            .decode(type: [Comic].self, decoder: ComicJSONDecoder())
            .map({ comics in
                print("comics = \(comics.count)")
                return comics
            })
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    var json: Data? {
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
