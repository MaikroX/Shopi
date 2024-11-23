//
//  ContentView.swift
//  Shopi
//
//  Created by Maik Langer on 23.11.24.
//
import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext // Core Data Kontext

    var body: some View {
        NavigationView {
            VStack {
                ItemListView() // Liste der Items
                Spacer()
                NewItemInputView() // Eingabefeld für neue Items
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        print("Alle Items löschen")
                    }) {
                        Label("Delete All", systemImage: "trash")
                    }
                }
            }
            .navigationTitle("Einkaufsliste")
        }
    }
}

// Vorschau für SwiftUI
#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
