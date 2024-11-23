import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext // Core Data Kontext

    var body: some View {
        NavigationView {
            VStack(spacing: 0) { // Kein zusätzlicher Abstand zwischen den Views
                ItemListView() // Liste der Items
                    .frame(maxHeight: .infinity) // Nimmt den restlichen Platz ein

                NewItemInputView() // Eingabefeld für neue Items
                    .background(Color(.systemBackground)) // Hintergrund fixieren
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

//TODO: Zustand der Checkbox speichern
//TODO: Checkbox etwas größer wie in V1
//TODO: Alle Items Löschen Funktion einbinden
//TODO: Überschrift mittig klein
//TODO: IM EDIT Mode statt des grünen Circles ein blauen circle mit haken zum bestätigen des edit und das textfeld ausblenden für neues Produkt eingeben, weil verwirrend
