//
//  ContentView.swift
//  Shopi
//
//  Created by Maik Langer on 23.11.24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        NavigationView {
            ItemListView() // Direkt die Child-View aufrufen
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            // Funktionalität für das Hinzufügen von Items (aktuell Platzhalter)
                            print("delete Button is tapped")
                        }) {
                            Label("Delete All", systemImage: "trash")
                        }
                    }
                }
                .navigationTitle("Items") // Beispielhafter Titel für die Navigation
        }
    }
}

// Vorschau für SwiftUI
#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
