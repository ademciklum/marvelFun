//
//  URLCache+ImageCache.swift
//  MarvelFun
//
//  Created by Artem Demchenko on 08.09.2022.
//

import Foundation

extension URLCache {
    
    static let imageCache = URLCache(memoryCapacity: 512*1000*1000, diskCapacity: 10*1000*1000*1000)
}
