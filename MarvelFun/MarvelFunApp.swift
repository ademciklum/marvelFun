//
//  MarvelFunApp.swift
//  MarvelFun
//
//  Created by Artem Demchenko on 04.09.2022.
//

import SwiftUI

@main
struct MarvelFunApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
