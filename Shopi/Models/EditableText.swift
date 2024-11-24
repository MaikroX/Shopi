import SwiftUI
import CoreData

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
