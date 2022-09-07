//
//  MarvelFunApp.swift
//  MarvelFun
//
//  Created by Artem Demchenko on 04.09.2022.
//

import SwiftUI

@main
struct MarvelFunApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(CharactersListViewModel())
        }
    }
}
