import SwiftUI

struct SwipeDownTest: View {
    // MARK: - State
    // Wir nutzen jetzt einen State für das Sheet, nicht mehr für das kleine Feld
    @State private var showCreateSheet: Bool = false
    
    // Konfiguration
    let triggerThreshold: CGFloat = 100.0 // Jetzt erst ab 100px Trigger (weniger sensibel)
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                
                // MARK: - ScrollView mit Detection
                ScrollView {
                    // Der "Tracker" muss IN der ScrollView ganz oben liegen
                    ZStack(alignment: .top) {
                        
                        // Unsichtbarer View zum Messen der Y-Position
                        GeometryReader { proxy -> Color in
                            let minY = proxy.frame(in: .named("pullToCreate")).minY
                            
                            // Logik-Check direkt hier (MainActor sicherstellen)
                            DispatchQueue.main.async {
                                handleScrollOffset(minY)
                            }
                            
                            return Color.clear
                        }
                        .frame(height: 0) // Nimmt keinen Platz weg
                        
                        // Dein Listen-Inhalt
                        VStack(spacing: 20) {
                            
                            // Header Title
                            HStack {
                                Text("Invites")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(.gray)
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 150)
                            
                            
                            // Liste der Items
                            ForEach(0..<15) { i in
                                InviteRow()
                            }
                        }
                    }
                }
                // WICHTIG: Dieser Name muss mit dem im GeometryReader übereinstimmen
                .coordinateSpace(name: "pullToCreate")
            }
            .padding(.top, 10)
        }
        // Hier wird die neue Seite als Sheet aufgeploppt
        .sheet(isPresented: $showCreateSheet) {
            InvitesCreateView()
        }
    }
    
    // MARK: - Logik
    func handleScrollOffset(_ offset: CGFloat) {
        
        // 1. Trigger-Logik: Wenn Offset > 100px und Sheet noch nicht offen
        if offset > triggerThreshold && !showCreateSheet {
            // Haptic Feedback (Vibration)
            let generator = UIImpactFeedbackGenerator(style: .heavy) // Etwas stärkeres Feedback
            generator.impactOccurred()
            
            // Sheet öffnen
            showCreateSheet = true
        }
    }
}

// MARK: - Neue Seite: InviteCreateView
struct InvitesCreateView: View {
    @Environment(\.dismiss) var dismiss
    @State private var inviteTitle: String = ""
    @FocusState private var isFocused: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.white.ignoresSafeArea()
                
                VStack(spacing: 30) {
                    
                    // Dein Custom Rechteck als Eingabefeld
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Was geht ab?")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.9))
                        
                        TextField("", text: $inviteTitle, prompt: Text("Kino, Party, Lernen...").foregroundColor(.white.opacity(0.6)))
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                            .focused($isFocused)
                    }
                    .padding(25)
                    .background(
                        LinearGradient(
                            colors: [Color.cyan.opacity(0.9), Color.orange.opacity(0.9)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(25)
                    .shadow(color: .orange.opacity(0.3), radius: 15, x: 0, y: 10)
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    Spacer()
                }
            }
            .navigationTitle("New Invite")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Erstellen") {
                        // Hier später Logik zum Speichern
                        dismiss()
                    }
                    .fontWeight(.bold)
                    .disabled(inviteTitle.isEmpty)
                }
            }
            .onAppear {
                // Tastatur sofort öffnen
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isFocused = true
                }
            }
        }
    }
}

// MARK: - Subviews
struct InviteRow: View {
    var body: some View {
        HStack {
            Circle()
                .frame(width: 50, height: 50)
                .foregroundColor(Color.gray.opacity(0.3))
            
            VStack(alignment: .leading, spacing: 8) {
                Rectangle()
                    .frame(height: 10)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color.gray.opacity(0.2))
                    .cornerRadius(5)
                
                Rectangle()
                    .frame(width: 100, height: 10)
                    .foregroundColor(Color.gray.opacity(0.2))
                    .cornerRadius(5)
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(15)
        .padding(.horizontal)
    }
}

#Preview {
    SwipeDownTest()
}
