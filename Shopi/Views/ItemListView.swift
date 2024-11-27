import SwiftUI
import CoreData

struct ItemListView: View {
    @Binding var isSorting: Bool // Zustand für den Sortiermodus
    @FetchRequest(
        entity: Item.entity(), // Core Data-Entität
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: false)], // Neueste zuerst
        animation: .default
    )
    var items: FetchedResults<Item>
    
    @Environment(\.managedObjectContext) private var viewContext // Core Data Kontext
    @State private var dragItems: [Item] = [] // Temporäre Speicherung für Drag-and-Drop

    var body: some View {
        Group {
            if items.isEmpty {
                // Leerer Zustand
                Spacer()
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
                    ForEach(dragItems) { item in
                        HStack {
                            EditableText(item: item) // Ausgelagert in separate Datei
                                .rotationEffect(isSorting ? .degrees(-2) : .degrees(0)) // Shake-Effekt
                                .animation(isSorting ? Animation.easeInOut(duration: 0.3).repeatForever(autoreverses: true) : .default, value: isSorting)
                            Spacer()
                            if !isSorting {
                                ToggleCircle(item: item)
                            }
                        }
                        .contentShape(Rectangle()) // Macht das gesamte Listenelement klickbar
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                deleteItem(item: item)
                            } label: {
                                Text("Löschen")
                            }
                        }
                    }
                    .onMove(perform: moveItems) // Drag-and-Drop aktivieren
                }
                .environment(\.editMode, isSorting ? .constant(.active) : .constant(.inactive)) // Sortiermodus aktivieren
                .scrollContentBackground(.hidden) // Entfernt den Hintergrund der List
                .background(Color(.separator))
            }
        }
        .onAppear {
            dragItems = Array(items) // Items initialisieren
        }
        .onChange(of: items.count) {
            dragItems = Array(items) // Drag-Liste aktualisieren
        }
    }

    private func moveItems(from source: IndexSet, to destination: Int) {
        dragItems.move(fromOffsets: source, toOffset: destination)
    }

    private func deleteItem(item: Item) {
        viewContext.delete(item)
        do {
            try viewContext.save()
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
// Test Commit
