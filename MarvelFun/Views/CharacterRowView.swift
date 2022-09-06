//
//  CharacterRowView.swift
//  MarvelFun
//
//  Created by Artem Demchenko on 05.09.2022.
//

import SwiftUI

struct CharacterRowView: View {
    
    let character: Character
    
    var body: some View {
        HStack {
            AsyncImage(url: character.thumbnail.composedImageURL, content: { image in
                image.resizable()
            }, placeholder: {
                ProgressView()
                    .frame(width: 50, height: 50)
            })
            .aspectRatio(contentMode: .fill)
            .frame(width: 70, height: 70, alignment: .topLeading)
            .cornerRadius(8.0)
            VStack(alignment: .leading) {
                Text(character.name)
                    .font(.headline)
                Text(character.description)
                    .font(.subheadline)
                    .lineLimit(3)
            }
        }
    }
}
