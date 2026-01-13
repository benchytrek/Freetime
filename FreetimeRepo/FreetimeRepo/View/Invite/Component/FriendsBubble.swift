//
//  FriendsBubble.swift
//  FreetimeRepo
//
//  Created by Ben Chytrek on 14.01.26.
//

import SwiftUI

struct FriendsBubble: View {
    // INPUT: Wir hören auf Änderungen dieses Strings (aus dem Textfeld)
    var inputString: String
    
    // INTERNAL STATE: Die Logik für die Partikel
    @State private var particles: [BubbleParticle] = []
    @State private var validSlots: [CGPoint] = []
    
    // CONFIG
    // Container ist 300x300, Icons sind 50 groß
    private let containerSize: CGFloat = 300
    private let iconSize: CGFloat = 50
    private let spacing: CGFloat = 8
    
    // Model für interne Nutzung
    struct BubbleParticle: Identifiable {
        let id = UUID()
        let user: User
        let index: Int
        let targetPosition: CGPoint
        let entranceOffset: CGSize
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            
            // Die Bubbles
            ForEach(particles) { particle in
                // HIER nutzen wir deine UserBubble mit dem Glow & Waber-Effekt
                UserBubble(user: particle.user, size: iconSize)
                    .position(particle.targetPosition)
                    
                    // ANIMATION: Reinfliegen (Transition)
                    // Der Waber-Effekt startet dann automatisch via .onAppear in der UserBubble
                    .transition(.asymmetric(
                        insertion: .offset(particle.entranceOffset).combined(with: .opacity),
                        removal: .scale
                    ))
                    // Z-Index sorgt dafür, dass neue Bubbles optisch "vor" den alten liegen
                    .zIndex(Double(particles.count - particle.index))
            }
        }
        .frame(width: containerSize, height: containerSize)
        // Fade-Out Effekt am unteren Rand
        .overlay(
            LinearGradient(
                stops: [
                    .init(color: .clear, location: 0.8),
                    .init(color: .black, location: 1.0) // Fade in den schwarzen Hintergrund
                ],
                startPoint: .top,
                endPoint: .bottom
            ),
            alignment: .bottom
        )
        // INITIALISIERUNG
        .onAppear {
            self.validSlots = generateOvalSlots()
        }
        // REAKTION AUF EINGABE
        .onChange(of: inputString) { oldValue, newValue in
            handleTyping(old: oldValue, new: newValue)
        }
    }
    
    // MARK: - Logic
    
    private func handleTyping(old: String, new: String) {
        if new.count > old.count {
            addParticle(index: new.count - 1)
        } else if new.count < old.count {
            removeParticle()
        }
    }
    
    private func addParticle(index: Int) {
        // Sicherstellen, dass wir noch Platz im Grid haben
        guard index < validSlots.count else { return }
        
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
            // Wir nehmen User aus der Mock-Liste "partyPeople"
            let user = UserData.partyPeople[index % UserData.partyPeople.count]
            let targetPos = validSlots[index]
            
            // Zufälliger Startpunkt weit oben für den "Schütten"-Effekt
            let randomStartX = CGFloat.random(in: -50...(containerSize + 50))
            let randomStartY = CGFloat.random(in: -500...(-100))
            
            let offset = CGSize(
                width: randomStartX - targetPos.x,
                height: randomStartY - targetPos.y
            )
            
            let particle = BubbleParticle(
                user: user,
                index: index,
                targetPosition: targetPos,
                entranceOffset: offset
            )
            particles.append(particle)
        }
    }
    
    private func removeParticle() {
        withAnimation(.easeOut(duration: 0.2)) {
            if !particles.isEmpty {
                particles.removeLast()
            }
        }
    }
    
    // Generiert die Positionen im Oval
    private func generateOvalSlots() -> [CGPoint] {
        var slots: [CGPoint] = []
        let centerX = containerSize / 2
        let centerY = containerSize / 2
        let radius = (containerSize / 2) - (iconSize / 2)
        
        let hexHeight = iconSize * 0.85
        let hexWidth = iconSize + spacing
        
        let rows = Int(containerSize / hexHeight) + 2
        let cols = Int(containerSize / hexWidth) + 2
        
        for row in -1...rows {
            for col in -1...cols {
                var x = CGFloat(col) * hexWidth
                let y = CGFloat(row) * hexHeight
                
                // Versatz für ungerade Reihen (Bienenwaben-Muster)
                if row % 2 != 0 { x += hexWidth / 2 }
                
                let finalX = x + 15
                let finalY = y + 20
                
                // Prüfen ob Punkt im Kreis liegt
                let dx = finalX - centerX
                let dy = finalY - centerY
                
                if sqrt(dx*dx + dy*dy) < radius {
                    slots.append(CGPoint(x: finalX, y: finalY))
                }
            }
        }
        
        // Sortieren nach Y (damit es von oben nach unten gefüllt wird)
        return slots.sorted {
            if abs($0.y - $1.y) > 10 { return $0.y < $1.y }
            else { return $0.x < $1.x }
        }
    }
}

#Preview {
    // Vorschau auf schwarzem Hintergrund, damit der Fade-Effekt sichtbar ist
    ZStack {
        Color.black.ignoresSafeArea()
        FriendsBubble(inputString: "Party!")
    }
}
