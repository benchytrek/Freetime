//
//  InviteCreateView.swift
//  FreetimeRepo
//
//  Created by Ben Chytrek on 13.01.26.
//

import SwiftUI

struct InviteCreateView: View {
    @Environment(\.dismiss) var dismiss
    
    // UI State
    @State private var title: String = ""
    @FocusState private var isTitleFocused: Bool
    
    // MARK: - PARTICLE SYSTEM
    struct UserParticle: Identifiable {
        let id = UUID()
        let user: User
        // Wir berechnen das Ziel (Grid Position) beim Erstellen
        let targetX: CGFloat
        let targetY: CGFloat
    }
    
    @State private var particles: [UserParticle] = []
    
    // Konfiguration für das "Apple Watch Grid"
    let bubbleSize: CGFloat = 60
    // Spacing muss etwas größer als Size sein für den Abstand
    let spacing: CGFloat = 65
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                
                // 1. HINTERGRUND
                Color.black.ignoresSafeArea() // Deep Black für maximalen Kontrast (Glow)
                    .onTapGesture { isTitleFocused = false }
                
                // 2. PARTIKEL LAYER (Mitte)
                // WICHTIG: Dieser Block kommt VOR dem Textfeld im Code,
                // damit er visuell UNTER dem Textfeld liegt.
                ZStack {
                    ForEach(particles) { particle in
                        WatchBubbleView(user: particle.user, size: bubbleSize)
                            // A) Die finale Position in der Mitte (Grid)
                            .offset(x: particle.targetX, y: particle.targetY)
                            // B) Der Einflug von GANZ OBEN
                            .transition(
                                .asymmetric(
                                    // Startpunkt: Weit über dem Bildschirmrand
                                    insertion: .offset(y: -UIScreen.main.bounds.height)
                                        // Optional: Leichtes Einzoomen beim Flug
                                        .combined(with: .scale(scale: 0.5))
                                        .combined(with: .opacity),
                                    // Beim Löschen: Einfach schrumpfen
                                    removal: .scale.combined(with: .opacity)
                                )
                            )
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .offset(y: 100) // Verschiebt das Zentrum der Wolke leicht nach unten in die Mitte
                
                // 3. VORDERGRUND (Input Field Balken)
                VStack(spacing: 0) {
                    
                    // TITEL EINGABE
                    ZStack(alignment: .center) {
                        // Der "Balken" - Glassmorphism Style
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.ultraThinMaterial) // Apple Milchglas-Effekt
                            .frame(width: 300, height: 60)
                            // Leichter Glow um den Balken selbst
                            .shadow(color: .white.opacity(0.15), radius: 10, x: 0, y: 5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(.white.opacity(0.2), lineWidth: 1)
                            )
                        
                        TextField("Was geht ab?", text: $title)
                            .font(.system(size: 20, weight: .bold))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.white) // Weißer Text auf dunklem Grund
                            .frame(width: 300)
                            .focused($isTitleFocused)
                    }
                    .padding(.top, 60)
                    .zIndex(100) // Zwingt den Balken visuell über die fliegenden Icons
                    
                    Spacer()
                }
            }
            .navigationTitle("New Invite")
            .navigationBarTitleDisplayMode(.inline)
            // Navbar Text weiß machen
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") { dismiss() }
                        .foregroundStyle(.white)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Erstellen") { dismiss() }
                        .disabled(title.isEmpty)
                        .fontWeight(.bold)
                        .foregroundStyle(.blue)
                }
            }
            // Tipp-Logik überwachen
            .onChange(of: title) { oldValue, newValue in
                handleTyping(old: oldValue, new: newValue)
            }
            .onAppear {
                // Tastatur startet automatisch (optional)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isTitleFocused = true
                }
            }
        }
    }
    
    // MARK: - LOGIC: PHYLLOTAXIS (Apple Watch Grid Math)
    
    func handleTyping(old: String, new: String) {
        if new.count > old.count {
            // Zeichen hinzugefügt -> Bubble reinfliegen lassen
            addParticle(index: new.count - 1)
        } else if new.count < old.count {
            // Zeichen gelöscht -> Bubble entfernen
            removeParticle()
        }
    }
    
    func addParticle(index: Int) {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
            // Wir nehmen einen User aus dem Mock-Pool
            // Modulo (%) sorgt dafür, dass wir nie Out-of-Bounds gehen, auch bei viel Text
            let user = UserData.partyPeople[index % UserData.partyPeople.count]
            
            // --- MATHEMATIK: SONNENBLUMEN SPIRALE ---
            // 1. Winkel: Goldener Winkel (ca 137.5 Grad in Radiant)
            let angle = Double(index) * 2.39996
            
            // 2. Radius: Wurzel aus Index sorgt für gleichmäßige Dichte
            // Multipliziert mit Spacing
            let radius = spacing * CGFloat(sqrt(Double(index)))
            
            // 3. Polarkoordinaten in X/Y umrechnen
            let x = radius * cos(angle)
            let y = radius * sin(angle)
            
            let particle = UserParticle(user: user, targetX: x, targetY: y)
            particles.append(particle)
        }
    }
    
    func removeParticle() {
        withAnimation(.easeOut(duration: 0.2)) {
            if !particles.isEmpty {
                particles.removeLast()
            }
        }
    }
}

// MARK: - SUBVIEW: BUBBLE (Solid & Glow)
struct WatchBubbleView: View {
    let user: User
    let size: CGFloat
    
    // State für das sanfte Wabern nach der Landung
    @State private var isWobbling = false
    
    // Erzeugt eine stabile Farbe basierend auf dem Namen
    var glowColor: Color {
        let colors: [Color] = [.blue, .purple, .pink, .cyan, .mint, .orange, .indigo]
        let index = abs(user.name.hashValue) % colors.count
        return colors[index]
    }
    
    var body: some View {
        ZStack {
            // 1. GLOW (Hintergrund)
            Circle()
                .fill(glowColor)
                .frame(width: size, height: size)
                .blur(radius: 10) // Starker Blur für den Glow
                .opacity(0.7)
            
            // 2. SOLID BODY (Vordergrund)
            Circle()
                .fill(
                    LinearGradient(
                        colors: [glowColor.opacity(0.8), glowColor],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size, height: size)
                .overlay(
                    // Leichter weißer Rand (Inset) für 3D Look
                    Circle().stroke(.white.opacity(0.3), lineWidth: 1.5)
                )
            
            // 3. INITIALE
            Text(user.name.prefix(1))
                .font(.system(size: size * 0.4, weight: .heavy, design: .rounded))
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.2), radius: 1, x: 1, y: 1)
        }
        // Wabern (Breathing Effect)
        .offset(
            x: isWobbling ? CGFloat.random(in: -2...2) : 0,
            y: isWobbling ? CGFloat.random(in: -2...2) : 0
        )
        .onAppear {
            // Startet asynchron, damit nicht alle synchron wackeln
            withAnimation(
                .easeInOut(duration: Double.random(in: 2.0...4.0))
                .repeatForever(autoreverses: true)
                .delay(Double.random(in: 0...0.5))
            ) {
                isWobbling = true
            }
        }
    }
}


#Preview {
    InviteCreateView()
}
