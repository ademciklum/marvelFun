//
//  ComicRowView.swift
//  MarvelFun
//
//  Created by Artem Demchenko on 06.09.2022.
//

import Foundation
import SwiftUI

struct ComicRowView: View {
    
    let comic: Comic
    
    var body: some View {
        VStack {
            AsyncImage(url: comic.thumbnail.composedImageURL, content: { image in
                image.resizable()
            }, placeholder: {
                ProgressView()
            })
            .aspectRatio(contentMode: .fill)
//            .frame(maxWidth: .infinity, maxHeight: 120, alignment: .topLeading)
            .cornerRadius(8.0)
            VStack(alignment: .leading) {
                Text(comic.title)
                    .font(.headline)
                Text(comic.description)
                    .font(.subheadline)
            }
        }
    }
}
