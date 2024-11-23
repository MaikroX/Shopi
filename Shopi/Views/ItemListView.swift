import SwiftUI
import CoreData

struct ItemListView: View {
    // Core Data FetchRequest direkt in der View
    @FetchRequest(
        entity: Item.entity(), // Core Data-Entität
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.name, ascending: true)], // Alphabetisch sortieren
        animation: .default // Standardanimation
    )
    var items: FetchedResults<Item>

    @Environment(\.managedObjectContext) private var viewContext // Core Data Kontext

    var body: some View {
        List {
            ForEach(items) { item in
                HStack {
                    Text(item.name ?? "Unbenannt") // Item-Namen anzeigen
                    Spacer()
                    ToggleCircle() // Platzhalter für den Kreis
                }
            }
            .onDelete(perform: deleteItems) // Swipe-to-Delete aktivieren
        }
    }

    // Funktion zum Löschen von Items
    private func deleteItems(at offsets: IndexSet) {
        offsets.map { items[$0] }.forEach(viewContext.delete) // Core Data-Objekte löschen
        do {
            try viewContext.save() // Änderungen speichern
        } catch {
            print("Fehler beim Löschen der Items: \(error.localizedDescription)")
        }
    }
}

// Eine eigene View für den Kreis mit Klick-Logik
struct ToggleCircle: View {
    @State private var isChecked: Bool = false

    var body: some View {
        Circle()
            .fill(isChecked ? Color.green : Color(UIColor.systemGray5))
            .frame(width: 20, height: 20)
            .overlay(
                           // Weißer Haken, nur wenn `isChecked == true`
                           isChecked ? Image(systemName: "checkmark")
                               .foregroundColor(.white) // Hakenfarbe
                               .font(.system(size: 12, weight: .bold)) // Haken-Größe und Gewicht
                           : nil
                       )
            .onTapGesture {
                isChecked.toggle()
            }
    }
}
