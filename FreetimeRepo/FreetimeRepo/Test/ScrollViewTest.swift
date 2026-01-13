import SwiftUI

struct ScrollViewTest: View {
    
    // Wir starten bei ID 1 (textSection), damit ID 0 (heroSection) versteckt ist
    @State private var scrollPosition: Int? = 1

    var body: some View {
        ScrollView {
            mainContent
                .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
        .scrollPosition(id: $scrollPosition)
        .scrollIndicators(.hidden)
        .onAppear {
            // Springt zum Start direkt zum Text, Hero ist "oben drüber" versteckt
            scrollPosition = 1
        }
    }
    
    // MARK: - Sub-Views
    
    @ViewBuilder
    private var mainContent: some View {
        VStack(spacing: 0) {
            heroSection   // ID 0
            textSection   // ID 1
            listSection   // ID 2...
        }
    }
    
    private var heroSection: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.green)
                .frame(height: 100)
                .frame(maxWidth: .infinity)
                .cornerRadius(20)
                .shadow(radius: 5)
                .padding(30)
            
            Text("Erstelle ein neuen invite")
        }
        // KORREKTUR: Modifier gehört AN den ZStack, nicht HINEIN
        .onTapGesture {
            print("lol")
        }
        .containerRelativeFrame(.vertical, count: 2, spacing: 20)
        .id(0) // ID 0 (Versteckt beim Start)
    }
    
    private var textSection: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.red)
                .frame(height: 100)
                .frame(maxWidth: .infinity)
                .cornerRadius(20)
                .shadow(radius: 5)
                .padding(30)
            
            Text("Jojo was geht ab")
        }
        .containerRelativeFrame(.vertical, count: 3, spacing: 30)
        .id(1) // KORREKTUR: ID 1 (Sichtbar beim Start)
    }
    
    private var listSection: some View {
        VStack(spacing: 20) {
            ForEach(0..<10) { index in
                Rectangle()
                    .foregroundColor(.blue)
                    .frame(height: 100)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(20)
                    .shadow(radius: 5)
                    .padding(.horizontal)
                    // KORREKTUR: IDs verschieben sich, da 0 und 1 belegt sind
                    .id(index + 2)
            }
        }
        .padding(.top, 20)
    }
}

#Preview {
    ScrollViewTest()
}
