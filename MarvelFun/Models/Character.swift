//
//  Character.swift
//  MarvelFun
//
//  Created by Artem Demchenko on 04.09.2022.
//

import Foundation

struct Character: Decodable, Identifiable {
    let id: Int
    let name: String
    let description: String
    let thumbnail: Image
    let comics: [Resource]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case thumbnail
        case comics
        case items
    }
    
    enum NestedCodingKeys: String, CodingKey {
        case items
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let comicsContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .comics)
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
        thumbnail = try container.decode(Image.self, forKey: .thumbnail)
        comics = try comicsContainer.decode([Resource].self, forKey: .items)
    }
}
