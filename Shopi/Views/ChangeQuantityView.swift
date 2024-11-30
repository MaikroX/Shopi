import SwiftUI

struct ChangeQuantityView: View {
    @Environment(\.dismiss) var dismiss // Um das Sheet zu schließen
    @ObservedObject var item: Item // Das Item, für das die Menge gespeichert wird
    @Environment(\.managedObjectContext) private var viewContext // Core Data Kontext

    @State private var selectedQuantity: Int // Erste Auswahl
    @State private var selectedUnit: String // Zweite Auswahl

    let quantities = Array(1...99) // Werte für das erste Scrollrad
    let units = ["Stück", "kg", "g", "L", "ml"] // Werte für das zweite Scrollrad

    init(item: Item) {
        self.item = item
        // Initialisiere die Auswahl basierend auf dem Item
        _selectedQuantity = State(initialValue: Int(item.quantity))
        _selectedUnit = State(initialValue: item.unit ?? "Stück")
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("Gib eine Menge an")
                .padding(.bottom, -16)
                .font(.headline)

            HStack {
                Picker("Menge", selection: $selectedQuantity) {
                    ForEach(quantities, id: \.self) { quantity in
                        Text("\(quantity)").tag(quantity)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(height: 150)

                Picker("Einheit", selection: $selectedUnit) {
                    ForEach(units, id: \.self) { unit in
                        Text(unit).tag(unit)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(height: 150)
            }

            Button(action: {
                saveChanges() // Änderungen speichern
                dismiss() // Sheet schließen
            }) {
                Text("OK")
                    .padding(.horizontal, 40)
                    .padding(.vertical, 10)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }

    private func saveChanges() {
        item.quantity = Int16(selectedQuantity) // Menge speichern
        item.unit = selectedUnit // Einheit speichern

        do {
            try viewContext.save() // Änderungen in Core Data speichern
        } catch {
            print("Fehler beim Speichern: \(error.localizedDescription)")
        }
    }
}
