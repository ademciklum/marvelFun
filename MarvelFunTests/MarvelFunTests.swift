//
//  MarvelFunTests.swift
//  MarvelFunTests
//
//  Created by Artem Demchenko on 04.09.2022.
//

import XCTest
import Combine
@testable import MarvelFun

class MarvelFunTests: XCTestCase {

    private var cancellables: Set<AnyCancellable> = []

    func testComicsMappingListViewModel() throws {
        let characterStub = CharacterStub(id: 1011334, name: "", description: "")
        let jsonName = "comics-for-cahracter-1011334"
        let mockNetworkService = MockComicsNetworkService(jsonName: jsonName)
        let comicsExpectation = expectation(description: "comicsExpectation")
        
        let model = ComicsListViewModel(characterStub, networkService: mockNetworkService)
        
        model.$comics.drop(while: { $0.isEmpty }).sink { _ in
            comicsExpectation.fulfill()
        }.store(in: &cancellables)
        
        model.loadComics()
        
        waitForExpectations(timeout: 5)
        XCTAssertEqual(model.comics.count, 4, "Comics mapped view model failure with comics count")
    }
}
