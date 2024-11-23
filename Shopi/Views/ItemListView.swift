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
                    EditableText(item: item) // Item-Namen anzeigen
                    Spacer()
                    ToggleCircle() // Platzhalter für den Kreis
                }
            }
            .onDelete(perform: deleteItems) // Swipe-to-Delete aktivieren
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
                Text(item.name ?? "Unbenannt")
                    .onTapGesture {
                        isEditing = true // Bearbeitungsmodus aktivieren
                    }
            }
        }
    }
    
    // ### ITEM LÖSCHEN ###
    private func deleteItems(at offsets: IndexSet) {
        offsets.map { items[$0] }.forEach(viewContext.delete)
        do {
            try viewContext.save() // Änderungen speichern
        } catch {
            print("Fehler beim Löschen der Items: \(error.localizedDescription)")
        }
    }
}


// ### KREIS wird CHECKED : UNCHECKED ###
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
