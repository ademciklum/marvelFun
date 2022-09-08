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
        List {
            Section {
                CharacterSectionHeaderView(character: viewModel.character)
            } header: {
                Text(viewModel.character.name)
                    .font(.title2)
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
        .refreshable { viewModel.loadComics() }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing:
            Menu("Sort") {
                Button("Date", action: {
                    viewModel.comics.sort(by: { a, b in
                        guard let dateA = a.publicationDate,
                                let dateB = b.publicationDate else {
                            return false
                        }
                        return dateA > dateB
                    })
                })
                Button("Title", action: {
                    viewModel.comics.sort(by: { $0.title > $1.title })
                })
            }
        )
        .onAppear {
            viewModel.loadComics()
        }
        .modifier(RetryAlertViewModifier(error: $viewModel.lastError, action: {
            viewModel.lastError = nil
            viewModel.loadComics()
        }))
    }
}

struct CharacterSectionHeaderView: View {
 
    let character: CharacterIdentifiable
    
    var body: some View {
        VStack(spacing: 8) {
            AsyncImage(url: character.thumbnail?.composedImageURL, content: { image in
                image.resizable()
            }, placeholder: {
                VStack { Color.cyan }
                    .frame(height: 320)
            })
            .background(.regularMaterial)
            .aspectRatio(contentMode: .fill)

            Text(character.description)
                .font(.subheadline)
                .padding(EdgeInsets(top: 0, leading: 8, bottom: 8, trailing: 8))
            
        }
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0))
    }
}
