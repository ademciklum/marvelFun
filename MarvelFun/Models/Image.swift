//
//  Image.swift
//  MarvelFun
//
//  Created by Artem Demchenko on 04.09.2022.
//

import Foundation

struct Image: Codable {
    let path: String
    let `extension`: String
    
    var composedImageURL: URL? {
        return URLRequestComposer.compose(path: path,
                                          extention: `extension`,
                                          authorizationRequired: true)
    }
}
