//
//  ContentView.swift
//  MarvelFun
//
//  Created by Artem Demchenko on 04.09.2022.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: CharactersListViewModel
    
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
            .disableAutocorrection(true)
            .refreshable {
                viewModel.reloadData()
            }
            .navigationBarTitle("Marvel fun")
        }
        .accentColor(.red)
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification)) { _ in viewModel.saveCharacters() }
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
        .overlay(Group {
            if viewModel.characters.isEmpty {
                Text("Oops, loos like there's no data...")
                    .font(.headline)
                    .transition(AnyTransition.asymmetric(insertion: AnyTransition.opacity.animation(Animation.default.delay(2)),
                                                         removal: AnyTransition.opacity))
            }
        })
    }
}
