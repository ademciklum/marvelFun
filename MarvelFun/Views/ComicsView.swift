//
//  ComicsView.swift
//  MarvelFun
//
//  Created by Artem Demchenko on 06.09.2022.
//

import SwiftUI

struct ComicsView: View {
    
    @ObservedObject var viewModel: ComicsListViewModel
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    CharacterSectionHeaderView(character: viewModel.character)
                } header: {
                    Text(viewModel.character.name)
                        .font(.title3)
                }
                Section {
                    ForEach(viewModel.comics) { comic in
                        ComicRowView(comic: comic)
                    }
                } header: {
                    Text("Comics")
                        .font(.headline)
                }
            }
            .listStyle(.sidebar)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
//            .navigationBarTitle(viewModel.character.name)
        }
        .onAppear {
            viewModel.loadComics()
        }
    }
}

struct CharacterSectionHeaderView: View {
 
    let character: Character
    
    var body: some View {
        VStack {
            AsyncImage(url: character.thumbnail.composedImageURL, content: { image in
                image.resizable()
            }, placeholder: {
                ProgressView()
            })
            .aspectRatio(contentMode: .fill)
            .cornerRadius(8.0)
            
            Text(character.description)
                .font(.subheadline)
        }
    }
}
