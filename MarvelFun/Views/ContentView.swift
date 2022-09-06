//
//  ContentView.swift
//  MarvelFun
//
//  Created by Artem Demchenko on 04.09.2022.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @EnvironmentObject var viewModel: CharactersListViewModel
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(viewModel.characters) { character in
                        NavigationLink {
                            ComicsView(viewModel: ComicsListViewModel(character))
                        } label: {
                            CharacterRowView(character: character)
                        }
                    }
                } header: {
                    Text("Characters")
                }
            }
            .listStyle(.sidebar)
            .searchable(text: $viewModel.search, prompt: "Search by name starts with..")
            .navigationBarTitle("Marvel fun")
        }
        .accentColor(.red)
    }
}
