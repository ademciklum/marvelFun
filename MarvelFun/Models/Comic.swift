//
//  Comic.swift
//  MarvelFun
//
//  Created by Artem Demchenko on 06.09.2022.
//

import Foundation

struct Comic: Decodable, Identifiable {
    let id: Int
    let digitalId: Int
    let title: String
    let description: String?
    let thumbnail: Image?
    let pageCount: Int
    let dates: [ComicDate]?
    
    var publicationDate: Date? {
        dates?.first(where: { $0.type == .onSaleDate })?.date
    }
    
    enum CodingKeys: String, CodingKey {
        case id, digitalId
        case title
        case description
        case thumbnail
        case pageCount
        case dates
    }
    
    enum NestedCodingKeys: String, CodingKey {
        case items
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        digitalId = try container.decode(Int.self, forKey: .digitalId)
        title = try container.decode(String.self, forKey: .title)
        description = try? container.decodeIfPresent(String.self, forKey: .description)
        thumbnail = try container.decodeIfPresent(Image.self, forKey: .thumbnail)
        pageCount = try container.decode(Int.self, forKey: .pageCount)
        dates = try container.decode([ComicDate].self, forKey: .dates)
    }
}

struct ComicDate: Decodable {
    let date: Date?
    let type: DateType
    
    enum DateType: String, Decodable {
        case onSaleDate = "onsaleDate" // publication date
        case focDate
        case unlimitedDate
        case digitalPurchaseDate
    }
    
    enum CodingKeys: String, CodingKey {
        case type
        case date
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        date = try? container.decodeIfPresent(Date.self, forKey: .date)
        type = try container.decode(DateType.self, forKey: .type)
    }
}
