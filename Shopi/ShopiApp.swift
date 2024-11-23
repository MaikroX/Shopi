//
//  ShopiApp.swift
//  Shopi
//
//  Created by Maik Langer on 23.11.24.
//

import SwiftUI

@main
struct ShopiApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
