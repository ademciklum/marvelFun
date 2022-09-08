//
//  DataTaskPublisher.swift
//  MarvelFun
//
//  Created by Artem Demchenko on 06.09.2022.
//

import Foundation
import Combine

public struct DataTaskPublisher: DataTaskPublisherProtocol {
    
    static func publisherForRequest<T>(_ request: URLRequest) -> AnyPublisher<T, Error> {
        publisherWithData(dataPublisherForRequest(request))
    }
    
    static func dataPublisherForRequest(_ request: URLRequest) -> AnyPublisher<Data, Error> {
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { $0.data }
            .retry(2)
            .eraseToAnyPublisher()
    }
    
    static func publisherWithData<T>(_ dataPublisher: AnyPublisher<Data, Error>) -> AnyPublisher<T, Error> {
        dataPublisher
            .tryMap({ data in
                guard let responseObject = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                      let dataDict = responseObject["data"] as? [String: Any],
                      let resultsDict = dataDict["results"] as? [Any],
                      let resultsData = try? JSONSerialization.data(withJSONObject: resultsDict) as? T else {
                    throw NSError(domain: "Parse error", code: NSURLErrorCannotParseResponse)
                }
                return resultsData
            })
            .retry(2)
            .eraseToAnyPublisher()
    }
}

protocol DataTaskPublisherProtocol {
    static func publisherForRequest<T>(_ request: URLRequest) -> AnyPublisher<T, Error>
}
