//
//  ContentView.swift
//  MarvelFun
//
//  Created by Artem Demchenko on 04.09.2022.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var viewModel: CharactersListViewModel
    @Environment(\.dismissSearch) private var dismissSearch
    
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
            .refreshable {
                viewModel.reloadData()
            }
            .navigationBarTitle("Marvel fun")
        }
        .accentColor(.red)
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification)) { _ in
            DataStorage().save(viewModel.characters)
        }
        .modifier(RetryAlertViewModifier(error: $viewModel.lastError, action: {
            viewModel.lastError = nil
            switch viewModel.lastError {
            case .defaultError:
                viewModel.loadCharacters()
            case .searchError:
                viewModel.loadSearch()
            default:
                break
            }
        }))
    }
}
