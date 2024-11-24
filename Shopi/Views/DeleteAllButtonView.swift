import SwiftUI
import CoreData

struct DeleteAllButtonView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: Item.entity(),
        sortDescriptors: []
    ) private var items: FetchedResults<Item>
    
    @State private var showAlert = false // Steuert die Anzeige des Alerts
    @State private var isButtonActive = false // Steuert den Aktivitätszustand des Buttons

    var body: some View {
        Button(action: {
            showAlert = true // Alert anzeigen
        }) {
            Label("Delete All", systemImage: "trash")
                .foregroundColor(isButtonActive ? .blue : .gray) // Farbe je nach Zustand
        }
        .disabled(!isButtonActive) // Button deaktivieren, wenn nicht aktiv
        .onAppear {
            updateButtonState() // Zustand beim Laden überprüfen
        }
        .onChange(of: items.count) {
            updateButtonState() // Zustand bei Änderungen aktualisieren
        }
        .alert("Möchtest du die Liste leeren?", isPresented: $showAlert) {
            Button("Ja", role: .destructive) {
                deleteAllItems() // Funktion zum Löschen aller Items
            }
            Button("Abbrechen", role: .cancel) {} // Alert schließen
        }
    }

    private func deleteAllItems() {
        for item in items {
            viewContext.delete(item) // Lösche jedes Item
        }
        do {
            try viewContext.save() // Änderungen speichern
            updateButtonState() // Zustand nach dem Löschen aktualisieren
        } catch {
            print("Fehler beim Löschen der Items: \(error.localizedDescription)")
        }
    }

    private func updateButtonState() {
        isButtonActive = !items.isEmpty // Aktivieren, wenn die Liste nicht leer ist
    }
}
