import SwiftUI

struct SwipDownTest: View {
    // MARK: - State
    @State private var scrollOffset: CGFloat = 0
    @State private var showCreateSheet: Bool = false
    @State private var hasTriggeredHaptic: Bool = false // Verhindert Dauer-Vibration
    @State private var isReadyToTrigger: Bool = false // Status: Bereit zum Feuern?
    
    // MARK: - Config
    private let pullThreshold: CGFloat = 110 // Schwelle für "Bereit"
    
    // Gradient für den Create Button
    let createGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 0.4, green: 0.9, blue: 0.9), // Cyan/Türkis
            Color(red: 1.0, green: 0.8, blue: 0.6)  // Pfirsich/Orange
        ]),
        startPoint: .leading,
        endPoint: .trailing
    )
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.white.ignoresSafeArea()
            
            // 1. DYNAMISCHER HEADER (HINTER DER LISTE)
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(createGradient)
                        .shadow(color: Color.orange.opacity(0.3), radius: 15, x: 0, y: 8)
                    
                    HStack(spacing: 12) {
                        Image(systemName: isReadyToTrigger ? "arrow.up.circle.fill" : "plus.circle.fill")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                            // Dreht sich, wenn bereit zum Loslassen
                            .rotationEffect(.degrees(isReadyToTrigger ? 180 : 0))
                            .scaleEffect(isReadyToTrigger ? 1.2 : 1.0)
                            .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isReadyToTrigger)
                        
                        Text(isReadyToTrigger ? "Loslassen zum Erstellen" : "Ziehen für neues Event")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .contentTransition(.numericText()) // Cooler Effekt beim Textwechsel (iOS 16+)
                    }
                }
                .frame(height: 80)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20)
                
                // Parallax & Opacity Logik
                .offset(y: (scrollOffset * 0.7))
                .opacity(min(Double(scrollOffset) / 80.0, 1.0))
                .scaleEffect(isReadyToTrigger ? 1.05 : 0.95)
                .animation(.interactiveSpring(), value: scrollOffset)
                
                Spacer()
            }
            .padding(.top, 50)
            .ignoresSafeArea()
            
            // 2. SCROLL CONTENT
            ScrollView {
                ZStack(alignment: .top) {
                    // Unsichtbarer Offset-Tracker
                    GeometryReader { geo in
                        Color.clear
                            .preference(key: ScrollOffsetPreferenceKey.self, value: geo.frame(in: .named("scroll")).minY)
                    }
                    .frame(height: 0) // Keine Höhe, nur Tracker
                    
                    VStack(alignment: .leading, spacing: 20) {
                        // Header Title "Invites"
                        Text("Invites")
                            .font(.system(size: 40, weight: .heavy, design: .default))
                            .foregroundColor(.black)
                            .padding(.top, 40)
                            .padding(.horizontal, 20)
                            .opacity(max(0, 1.0 - (Double(scrollOffset) / 100.0)))
                            .blur(radius: scrollOffset > 50 ? 5 : 0)
                        
                        // Mock-Liste
                        LazyVStack(spacing: 16) {
                            ForEach(1...15, id: \.self) { index in
                                InviteRow(index: index)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 50)
                    }
                }
            }
            .coordinateSpace(name: "scroll")
            // Hier passiert die gesamte Logik
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                // Glätten kleiner negativer Bounces
                let currentOffset = value > 0 ? value : 0
                
                // Wenn wir gerade loslassen (Offset springt schnell zurück), prüfen wir Trigger
                // Ein drastischer Abfall deutet auf "Loslassen" hin, aber wir nutzen hier den Status 'isReadyToTrigger'
                if currentOffset < pullThreshold && isReadyToTrigger {
                    // Wir waren bereit und der Offset fällt -> User hat losgelassen!
                    triggerCreateAction()
                    isReadyToTrigger = false // Reset
                }
                
                self.scrollOffset = currentOffset
                
                // PRÜFEN: SIND WIR ÜBER DER GRENZE?
                if currentOffset > pullThreshold {
                    if !isReadyToTrigger {
                        // Statuswechsel: Jetzt bereit!
                        isReadyToTrigger = true
                        
                        // TACK! (Einmaliges Haptic Feedback beim Überschreiten)
                        let generator = UIImpactFeedbackGenerator(style: .heavy)
                        generator.prepare()
                        generator.impactOccurred()
                    }
                } else {
                    // Unter der Grenze -> Nicht bereit
                    if isReadyToTrigger && currentOffset < (pullThreshold - 10) {
                        // Kleine Hysterese (10pt), damit es nicht flackert
                        isReadyToTrigger = false
                    }
                }
            }
        }
        .sheet(isPresented: $showCreateSheet) {
            CreateInviteMockView()
        }
    }
    
    // MARK: - Actions
    func triggerCreateAction() {
        // Erfolg-Haptik (Vibration)
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.success)
        
        showCreateSheet = true
    }
}

// MARK: - Subviews & Helpers

struct InviteRow: View {
    let index: Int
    var body: some View {
        HStack(spacing: 15) {
            // Avatar Placeholder
            Circle()
                .fill(LinearGradient(colors: [.gray.opacity(0.3), .gray.opacity(0.1)], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 50, height: 50)
                .overlay(Text("\(index)").font(.caption).bold().foregroundColor(.gray))
            
            VStack(alignment: .leading, spacing: 8) {
                // Name Placeholder
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.primary.opacity(0.8))
                    .frame(width: 120, height: 16)
                
                // Detail Placeholder
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.primary.opacity(0.2))
                    .frame(width: 80, height: 12)
            }
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        // Schatten für Tiefe (wie im Video Design)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct CreateInviteMockView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()
                Image(systemName: "paperplane.fill")
                    .font(.system(size: 70))
                    .foregroundStyle(LinearGradient(colors: [.cyan, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .symbolEffect(.bounce, value: true) // iOS 17 Animation
                
                Text("Neues Event erstellen")
                    .font(.title2.bold())
                
                Text("Hier kommt dein Flow hin.\nZeit Freunde einzuladen!")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                Spacer()
            }
            .navigationTitle("Erstellen")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    SwipDownTest()
}
