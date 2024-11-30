import SwiftUI
import CoreData

struct ItemListView: View {
    @Binding var isSorting: Bool // Zustand für den Sortiermodus
    @FetchRequest(
        entity: Item.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.sortOrder, ascending: true)],
        animation: .default
    )
    var items: FetchedResults<Item>
    
    @Environment(\.managedObjectContext) private var viewContext
    @State private var dragItems: [Item] = [] // Temporäre Speicherung für Drag-and-Drop

    var body: some View {
        Group {
            if items.isEmpty {
                Spacer()
                VStack {
                    Text("Deine Einkaufsliste ist leer")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                    Spacer()
                }
            } else {
                List {
                    ForEach(dragItems) { item in
                        HStack {
                            
                            AddQuantityView(item: item)
                            Divider()
                                .frame(height: 30)
                            EditableText(item: item)
                                .rotationEffect(isSorting ? .degrees(-2) : .degrees(0))
                                .animation(isSorting ? Animation.easeInOut(duration: 0.3).repeatForever(autoreverses: true) : .default, value: isSorting)
                            ShowQuantityView(item: item) // Anzeige der Menge
                            Spacer()
                            if !isSorting {
                                ToggleCircle(item: item)
                            }
                        }
                        .contentShape(Rectangle())
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                deleteItem(item: item)
                            } label: {
                                Text("Löschen")
                            }
                        }
                    }
                    .onMove(perform: moveItems)
                }
                .environment(\.editMode, isSorting ? .constant(.active) : .constant(.inactive))
                .scrollContentBackground(.hidden)
                .background(Color(.separator))
            }
        }
        .onAppear {
            dragItems = Array(items)
        }
        .onChange(of: items.count) {
            dragItems = Array(items)
        }
    }

    private func moveItems(from source: IndexSet, to destination: Int) {
        dragItems.move(fromOffsets: source, toOffset: destination)
        
        for (index, item) in dragItems.enumerated() {
            item.sortOrder = Int32(index)
        }
        saveContext()
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("Fehler beim Speichern: \(error.localizedDescription)")
        }
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

// ShowQuantityView zur Anzeige von Menge und Einheit
struct ShowQuantityView: View {
    @ObservedObject var item: Item
// TODO: DIE EINHEITEN IN KLAMMERN ANGEBEN und weiter UNTEN gestetzt
// TODO: wenn unit editor geöffnet und keine Zahl geändert und dann Maßeinheit angeben, dann immer 1
// TODO: Bei Stückzahl statt Picker ggf andere Methode, weil 750 und Komma bspw. sonst nervig
    var body: some View {
        HStack {
            HStack {
                
                Text(item.quantity > 0 ? "\(item.quantity)" : "")
            }
            HStack {
                
                Text(item.unit ?? "")
            }
        }
        .font(.caption)
        .foregroundColor(.gray)
    }
}

// ToggleCircle zur Checkbox-Funktionalität
struct ToggleCircle: View {
    @ObservedObject var item: Item

    var body: some View {
        Circle()
            .fill(item.isChecked ? Color.green : Color(UIColor.systemGray5))
            .frame(width: 25, height: 25)
            .overlay(
                item.isChecked
                    ? Image(systemName: "checkmark")
                        .foregroundColor(.white)
                        .font(.system(size: 15, weight: .bold))
                    : nil
            )
            .onTapGesture {
                item.isChecked.toggle()
                saveContext()
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
