//
//  CharacterRowView.swift
//  MarvelFun
//
//  Created by Artem Demchenko on 05.09.2022.
//

import SwiftUI
import CachedAsyncImage

struct CharacterRowView: View {
    
    let character: Character
    
    var body: some View {
        HStack(spacing: 16) {
            CachedAsyncImage(url: character.thumbnail?.composedImageURL, content: { image in
                image.resizable()
            }, placeholder: {
                ProgressView()
                    .frame(width: 50, height: 50)
            })
            .aspectRatio(contentMode: .fill)
            .frame(width: 70, height: 70, alignment: .topLeading)
            .cornerRadius(8.0)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(character.name)
                    .font(.headline)
                Text(character.description)
                    .font(.subheadline)
                    .lineLimit(3)
            }
        }
    }
}
