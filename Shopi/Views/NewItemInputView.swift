import SwiftUI
import CoreData

struct NewItemInputView: View {
    @Environment(\.managedObjectContext) private var viewContext // Core Data Kontext
    @State private var newItemName: String = "" // Eingabefeld

    var body: some View {
        VStack(spacing: 0){
            Divider()
            HStack {
                TextField("Neues Produkt eingeben", text: $newItemName)
                    .padding(10) // Innenabstand für mehr Platz
                       .background(Color(.systemGray6)) // Hintergrundfarbe für das Textfeld
                       .clipShape(Capsule()) // Runde Ecken im iOS-Stil
                
                Button(action: addItem) {
                    Image(systemName: "plus.circle") // Plus-Symbol
                        .foregroundColor(.blue)
                        .padding()
                        .font(.system(size: 36))
                }
                .contentShape(Rectangle())
                .disabled(newItemName.trimmingCharacters(in: .whitespaces).isEmpty) // Deaktiviert, wenn leer
            }
            .padding(.horizontal) // Nur horizontales Padding beibehalten
            .padding(.top, 0) // Oberes Padding der gesamten View auf 0 setzen
        }
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
