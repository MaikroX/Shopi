import SwiftUI
import CoreData

struct NewItemInputView: View {
    @Environment(\.managedObjectContext) private var viewContext // Core Data Kontext
    @State private var newItemName: String = "" // Eingabefeld

    var body: some View {
        HStack {
            TextField("Neues Produkt eingeben", text: $newItemName)
                .textFieldStyle(RoundedBorderTextFieldStyle()) // Optischer Stil
                .padding(.vertical, 8)

            Button(action: addItem) {
                Image(systemName: "plus.circle") // Plus-Symbol
                    .foregroundColor(.blue)
                    .padding()
                    .font(.system(size: 36))
            }.contentShape(Rectangle())
            .disabled(newItemName.trimmingCharacters(in: .whitespaces).isEmpty) // Deaktiviert, wenn leer
        }
        .padding()
    }

    // Neue Items hinzufügen
    private func addItem() {
        let newItem = Item(context: viewContext)
        newItem.id = UUID() // Generiere eine eindeutige ID
        newItem.name = newItemName.trimmingCharacters(in: .whitespaces)
        do {
            try viewContext.save()
            newItemName = "" // Eingabefeld leeren
        } catch {
            print("Fehler beim Hinzufügen des Items: \(error.localizedDescription)")
        }
    }
}
