//
//  ComicRowView.swift
//  MarvelFun
//
//  Created by Artem Demchenko on 06.09.2022.
//

import Foundation
import SwiftUI
import CachedAsyncImage

struct ComicRowView: View {
    
    let comic: Comic
    
    var body: some View {
        VStack {
            comic.publicationDate.map { date in
                Text(DateFormatter.comicViewDateFormatter.string(from: date))
                    .frame(maxWidth: .infinity, alignment: .bottomTrailing)
                    .font(.footnote)
            }
            
            CachedAsyncImage(url: comic.thumbnail.composedImageURL, content: { image in
                image.resizable()
            }, placeholder: {
                ProgressView()
            })
            .aspectRatio(contentMode: .fill)
            .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(comic.title)
                    .font(.headline)
                comic.description.map { description in
                    Text(description)
                        .font(.subheadline)
                }
            }
        }
        .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
    }
}
