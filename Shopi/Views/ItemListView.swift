import SwiftUI
import CoreData

struct ItemListView: View {
    // Core Data FetchRequest direkt in der View
    @FetchRequest(
        entity: Item.entity(), // Core Data-Entität
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: false)], // Neueste zuerst
        animation: .default // Standardanimation
    )
    var items: FetchedResults<Item>
    
    @Environment(\.managedObjectContext) private var viewContext // Core Data Kontext
    
    var body: some View {
        Group {
            if items.isEmpty {
                Spacer()
                // Leerer Zustand
                VStack {
                    Text("Deine Einkaufsliste ist leer")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                    Spacer()
                }
            } else {
                // Liste der Items
                List {
                    ForEach(items) { item in
                        HStack {
                            EditableText(item: item) // Item-Namen anzeigen
                            Spacer()
                            ToggleCircle(item: item) // Platzhalter für den Kreis
                        }
                        .swipeActions(edge: .trailing) { // Swipe-Aktionen definieren
                            Button(role: .destructive) {
                                deleteItem(item: item) // Einzelnes Item löschen
                            } label: {
                                Text("Löschen") // Angepasster Text
                            }
                        }
                    }
                }
                .scrollContentBackground(.hidden) // Entfernt den Hintergrund der List
                .background(Color(.separator))
            }
        }
    }
    
    // ### ITEM EDITIEREN ###
    struct EditableText: View {
        @ObservedObject var item: Item // Beobachtetes Core Data-Objekt
        @State private var isEditing: Bool = false // Zustand: Bearbeitungsmodus
        @FocusState private var isTextFieldFocused: Bool // Fokus für TextField
        
        var body: some View {
            if isEditing {
                TextField("Unbenannt", text: Binding(
                    get: { item.name ?? "" },
                    set: { newValue in
                        item.name = newValue
                        try? item.managedObjectContext?.save() // Änderungen speichern
                    }
                ))
                .focused($isTextFieldFocused)
                .onAppear {
                    isTextFieldFocused = true // Fokus setzen
                }
                .onSubmit {
                    isEditing = false // Bearbeitungsmodus beenden
                }
            } else {
                Text(item.name ?? "")
                    .strikethrough(item.isChecked, color: .gray) // Durchgestrichen, wenn isChecked true ist
                    .foregroundColor(item.isChecked ? .gray : .primary)
                    .animation(.easeInOut(duration: 0.3), value: item.isChecked)
                    .onTapGesture {
                        isEditing = true // Bearbeitungsmodus aktivieren
                    }
            }
        }
    }
    
    // ### ITEM LÖSCHEN ###
    private func deleteItem(item: Item) {
        viewContext.delete(item)
        do {
            try viewContext.save() // Änderungen speichern
        } catch {
            print("Fehler beim Löschen des Items: \(error.localizedDescription)")
        }
    }
}


// ### KREIS wird CHECKED : UNCHECKED ###
struct ToggleCircle: View {
    @ObservedObject var item: Item
    
    var body: some View {
        Circle()
            .fill(item.isChecked ? Color.green : Color(UIColor.systemGray5))
            .frame(width: 25, height: 25)
            .overlay(
                // Weißer Haken, nur wenn `isChecked == true`
                item.isChecked ? Image(systemName: "checkmark")
                    .foregroundColor(.white) // Hakenfarbe
                    .font(.system(size: 15, weight: .bold)) // Haken-Größe und Gewicht
                : nil
            )
            .onTapGesture {
                item.isChecked.toggle() // Zustand ändern
                saveContext() // Core Data speichern
            }
    }
    private func saveContext() {
        do {
            try item.managedObjectContext?.save()
        } catch {
            print("Fehler beim Speichern: \(error.localizedDescription)")
        }
    }
}
