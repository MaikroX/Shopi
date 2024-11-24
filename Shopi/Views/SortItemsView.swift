import SwiftUI

struct SortItemsView: View {
    @Binding var isSorting: Bool // Zustand, ob der Sortiermodus aktiv ist
    @State private var rotationAngle: Double = 0 // Winkel für die Drehung

    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.3)) { // Animation hinzufügen
                isSorting.toggle() // Sortiermodus umschalten
                rotationAngle += 180 // Winkel um 180° erhöhen
            }
        }) {
            Image(systemName: "arrow.up.arrow.down") // Sortier-Icon von SF Symbols
                .font(.title2)
                .foregroundColor(isSorting ? .orange : .blue) // Farbe ändern
                .rotationEffect(.degrees(rotationAngle)) // Drehung anwenden
        }
    }
}
