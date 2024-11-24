import SwiftUI

struct SortItemsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: Item.entity(),
        sortDescriptors: []
    ) private var items: FetchedResults<Item>
    @Binding var isSorting: Bool // Zustand, ob der Sortiermodus aktiv ist
    @State private var rotationAngle: Double = 0 // Winkel für die Drehung
    @State private var isButtonActive: Bool = false // Steuert den Aktivitätszustand des Buttons

    var body: some View {
        Button(action: {
            if isButtonActive { // Nur ausführen, wenn aktiv
                withAnimation(.easeInOut(duration: 0.3)) { // Animation hinzufügen
                    isSorting.toggle() // Sortiermodus umschalten
                    rotationAngle += 180 // Winkel um 180° erhöhen
                }
            }
        }) {
            Image(systemName: "arrow.up.arrow.down") // Sortier-Icon von SF Symbols
                
                .foregroundColor(isButtonActive ? (isSorting ? .orange : .blue) : Color(UIColor.systemGray)) // Konsistentes Grau
                .rotationEffect(.degrees(rotationAngle)) // Drehung anwenden
                .opacity(isButtonActive ? 1.0 : 0.3) // Transparenz abhängig vom Zustand
        }
        .onAppear {
            updateButtonState() // Zustand beim Laden überprüfen
        }
        .onChange(of: items.count) {
            updateButtonState() // Zustand bei Änderungen aktualisieren
        }
    }

    private func updateButtonState() {
        isButtonActive = !items.isEmpty // Aktivieren, wenn die Liste nicht leer ist
    }
}
