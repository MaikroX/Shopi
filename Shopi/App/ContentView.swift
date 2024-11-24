import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext // Core Data Kontext

    var body: some View {
        NavigationView {
            VStack(spacing: 0.0) { // Kein zusätzlicher Abstand zwischen den Views
                ItemListView()
                    .frame(maxHeight: .infinity) // Nimmt den restlichen Platz ein

                NewItemInputView()
                    .background(Color(.systemBackground)) // Hintergrund fixieren
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    DeleteAllButtonView() // Verwende den separaten Button
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


//TODO: Zustand der Checkbox speichern ...ERLEDIGT
//TODO: Checkbox etwas größer wie in V1 ...ERLEDIGT
//TODO: Alle Items Löschen Funktion einbinden ... ERLEDIGT
//TODO: Überschrift mittig klein
//TODO: IM EDIT Mode statt des grünen Circles ein blauen circle mit haken zum bestätigen des edit und das textfeld ausblenden für neues Produkt eingeben, weil verwirrend
