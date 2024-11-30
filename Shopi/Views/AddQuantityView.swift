import SwiftUI

struct AddQuantityView: View {
    @State private var isChangeQuantityViewPresented: Bool = false
    @ObservedObject var item: Item // Übergabe des Items

    var body: some View {
        VStack {
            Image(systemName: "ellipsis")
                .font(.system(size: 20))
                .foregroundColor(.gray)
                .rotationEffect(.degrees(90))
                .padding(.leading, -4)
                .onTapGesture {
                    isChangeQuantityViewPresented = true // Neue View anzeigen
                    print("Ellipsis tapped")
                }
        }
        .sheet(isPresented: $isChangeQuantityViewPresented) {
            ChangeQuantityView(item: item) // Das jeweilige Item übergeben
                .presentationDetents([.fraction(0.4)]) // Höhe auf 40% des Bildschirms begrenzen
                .presentationDragIndicator(.visible) // Typischer iOS-Indikator anzeigen
        }
    }
}
