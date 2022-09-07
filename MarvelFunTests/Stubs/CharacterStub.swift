//
//  CharacterStub.swift
//  MarvelFunTests
//
//  Created by Artem Demchenko on 07.09.2022.
//

import Foundation
@testable import MarvelFun

struct CharacterStub: CharacterIdentifiable {
    let id: Int
    var name: String
    var description: String
    var thumbnail: Image? = nil
}
