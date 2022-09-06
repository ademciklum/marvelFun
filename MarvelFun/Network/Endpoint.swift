//
//  Endpoint.swift
//  MarvelFun
//
//  Created by Artem Demchenko on 04.09.2022.
//

import Foundation

public enum Endpoint {
    case characters
    case characterComics(_ characterId: Int)
    
    var stringValue: String {
        switch self {
        case .characters:
            return "/characters"
        case .characterComics(let characterId):
            return "/characters/\(characterId)/comics"
        }
    }
    
    var authorizationRequired: Bool {
        switch self {
        case .characters, .characterComics: return true
        }
    }
}
