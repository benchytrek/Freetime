import SwiftUI

struct SwipeSearchTestView: View {
    // MARK: - State
    @State private var isSearching: Bool = false
    @State private var searchText: String = ""
    @State private var dragOffset: CGFloat = 0
    @FocusState private var isInputFocused: Bool
    
    // MARK: - Constants & Config
    private let threshold: CGFloat = 120 // Punkt, ab dem die Suche einrastet
    private let maxDrag: CGFloat = 250
    
    // Farben aus dem Video (Cyan/Türkis zu Pfirsich/Orange)
    let gradientColors = Gradient(colors: [
        Color(red: 0.4, green: 0.9, blue: 0.9), // Cyan/Türkis
        Color(red: 1.0, green: 0.8, blue: 0.6)  // Pfirsich/Orange
    ])
    
    var body: some View {
        ZStack(alignment: .top) {
            
            // 1. HINTERGRUND
            Color.white.ignoresSafeArea()
            
            // 2. SEARCH PILL (Der "Liquid" Layer)
            // Sie liegt technisch "hinter" oder "über" dem Content, je nach gewünschtem Effekt.
            // Im Video wirkt es so, als würde sie enthüllt werden.
            GeometryReader { geo in
                let progress = min(max(dragOffset / threshold, 0), 1.0)
                
                // Dynamische Breite und Position
                let searchBarWidth = isSearching ? geo.size.width - 40 : 120 + (progress * 150)
                let searchBarHeight: CGFloat = 55
                
                // Y-Position:
                // Dragging: Bewegt sich mit dem Finger, aber etwas langsamer (Parallax)
                // Searching: Fixiert auf Position 60
                let yPos = isSearching ? 60 : -50 + (dragOffset * 0.5)
                
                ZStack {
                    if dragOffset > 10 || isSearching {
                        RoundedRectangle(cornerRadius: 28, style: .continuous)
                            .fill(
                                LinearGradient(
                                    gradient: gradientColors,
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            // "Liquid Glass" Shadow
                            .shadow(color: Color.orange.opacity(0.3), radius: 15, x: 0, y: 10)
                            .frame(width: searchBarWidth, height: searchBarHeight)
                            .overlay(
                                // Inhalt der Search Bar
                                ZStack {
                                    if isSearching {
                                        // Aktiver Such-Modus
                                        HStack {
                                            Image(systemName: "magnifyingglass")
                                                .foregroundColor(.white.opacity(0.7))
                                            
                                            TextField("", text: $searchText)
                                                .placeholder(when: searchText.isEmpty) {
                                                    Text("Typeee......").foregroundColor(.white.opacity(0.6))
                                                }
                                                .focused($isInputFocused)
                                                .foregroundColor(.white)
                                                .submitLabel(.search)
                                                .onSubmit { closeSearch() }
                                            
                                            Button(action: closeSearch) {
                                                Image(systemName: "xmark.circle.fill")
                                                    .foregroundColor(.white.opacity(0.8))
                                            }
                                        }
                                        .padding(.horizontal, 20)
                                        .transition(.opacity)
                                    } else {
                                        // Während dem Ziehen (Optionaler Text oder leer lassen für Clean Look)
                                        Text("Search")
                                            .font(.system(size: 16, weight: .bold, design: .rounded))
                                            .foregroundColor(.white.opacity(progress))
                                            .opacity(progress > 0.6 ? 1 : 0)
                                    }
                                }
                            )
                            .position(x: geo.size.width / 2, y: yPos)
                            .animation(.spring(response: 0.5, dampingFraction: 0.7), value: isSearching)
                            .animation(.interactiveSpring(), value: dragOffset)
                    }
                }
            }
            .zIndex(2) // Liegt über der Liste
            
            // 3. CONTENT LAYER (Liste mit Header "Invites")
            VStack(alignment: .leading, spacing: 100) {
                
                // Header Title
                Text("Invites")
                    .font(.system(size: 40, weight: .bold, design: .default))
                    .foregroundColor(Color(UIColor.label))
                    .padding(.top, 60)
                    .padding(.horizontal, 20)
                    .opacity(isSearching ? 0 : 1) // Fadet aus beim Suchen
                    .blur(radius: isSearching ? 10 : 0)
                
                // Simulierter Listen-Inhalt (Placeholder Rows aus dem Video)
                ScrollView(.vertical, showsIndicators: true) {
                    VStack(spacing: 15) {
                        ForEach(0..<15) { i in
                            HStack(spacing: 15) {
                                Circle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 50, height: 50)
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(width: 150, height: 12)
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.gray.opacity(0.15))
                                        .frame(width: 100, height: 12)
                                }
                                Spacer()
                            }
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(16)
                        }
                        
                        // Spacer am Ende
                        Color.clear.frame(height: 50)
                    }
                    .padding(.horizontal, 20)
                }
                // .scrollDisabled(true) <-- ENTFERNT, damit man scrollen kann
                .opacity(isSearching ? 0 : 1) // Liste verschwindet beim Suchen
                .blur(radius: isSearching ? 10 : 0)
            }
            // Die gesamte Liste bewegt sich nach unten
            .offset(y: isSearching ? 0 : dragOffset)
            .animation(.spring(response: 0.5, dampingFraction: 0.7), value: isSearching)
            
            // GESTURE HANDLER (Über dem ganzen Screen)
            .contentShape(Rectangle())
            .gesture(
                DragGesture()
                    .onChanged { value in
                        guard !isSearching else { return }
                        let translation = value.translation.height
                        
                        if translation > 0 {
                            // Logarithmischer Widerstand (Gummiband)
                            // pow(Double(translation), 0.85) macht es "schwerer", je weiter man zieht
                            dragOffset = CGFloat(pow(Double(translation), 0.85)) * 1.5
                        }
                    }
                    .onEnded { value in
                        guard !isSearching else { return }
                        
                        if dragOffset > threshold {
                            triggerSearch()
                        } else {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                dragOffset = 0
                            }
                        }
                    }
            )
            
            // Abbrechen-Area (Wenn man sucht, kann man unten tippen zum Schließen)
            if isSearching {
                Color.white.opacity(0.01)
                    .padding(.top, 150)
                    .onTapGesture {
                        closeSearch()
                    }
            }
        }
    }
    
    // MARK: - Logic
    
    func triggerSearch() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
            isSearching = true
            dragOffset = 0 // Reset drag, Pill geht auf feste Position
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            isInputFocused = true
        }
    }
    
    func closeSearch() {
        isInputFocused = false
        searchText = ""
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            isSearching = false
        }
    }
}

// Helper
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

struct SwipeSearchTestView_Previews: PreviewProvider {
    static var previews: some View {
        SwipeSearchTestView()
    }
}
