import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext // Core Data Kontext
    @State private var isSorting: Bool = false // Zustand für den Sortiermodus
    @State private var isEditing: Bool = false


    var body: some View {
        
        NavigationView {
            VStack(spacing: 0.0) { // Kein zusätzlicher Abstand zwischen den Views
                ItemListView(isSorting: $isSorting) // Binding für Sortierzustand übergeben
                    .frame(maxHeight: .infinity) // Nimmt den restlichen Platz ein
                if !isSorting {
                    NewItemInputView()
                        .background(Color(.systemBackground)) // Hintergrund fixieren
                }

                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    SortItemsView(isSorting: $isSorting) // Sortier-Button mit Binding
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    DeleteAllButtonView(isSorting: $isSorting)
                }
            }
            .navigationTitle(isSorting ? "Sortieren" : "Einkaufsliste")
        }
        
    }
}


// Vorschau für SwiftUI
#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}


//TODO: Sortierung speichern auf Gerät
//TODO: SortierungsIcon anpassen - Größe
//TODO: Einkaufsliste ist leer design anpassen an aktuelles design
//TODO: Überschrift mittig klein
//TODO: IM EDIT Mode statt des grünen Circles ein blauen circle mit haken zum bestätigen des edit und das textfeld ausblenden für neues Produkt eingeben, weil verwirrend
