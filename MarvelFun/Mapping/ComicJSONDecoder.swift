//
//  ComicJSONDecoder.swift
//  MarvelFun
//
//  Created by Artem Demchenko on 06.09.2022.
//

import Foundation

class ComicJSONDecoder: JSONDecoder {
    override init() {
        super.init()
        dateDecodingStrategy = .formatted(DateFormatter.comicDateFormatter)
    }
}
