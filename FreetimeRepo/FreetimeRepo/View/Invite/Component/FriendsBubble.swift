//
//  FriendsBubble.swift
//  FreetimeRepo
//
//  Created by Ben Chytrek on 13.01.26.
//

import SwiftUI

import Foundation

struct UserParticle: Identifiable {
    let id = UUID()
    let user: User
    // Grid Position
    let targetX: CGFloat
    let targetY: CGFloat
}


struct FriendsBubble: View {
    // Daten kommen von der Eltern-View
    let particles: [UserParticle]
    
    // Layout Konstanten (Apple Watch Style)
    private let bubbleSize: CGFloat = 60
    private let spacing: CGFloat = 65
    
    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                // Deine existierende UserBubble Komponente
                UserBubble(user: particle.user, size: bubbleSize)
                    // A) Positionierung relativ zur Mitte (0,0) des 400x400 Frames
                    .offset(x: particle.targetX, y: particle.targetY)
                    
                    // B) Einflug-Animation (bleibt erhalten)
                    .transition(
                        .asymmetric(
                            insertion: .offset(y: -UIScreen.main.bounds.height) // Kommt von ganz oben
                                .combined(with: .scale(scale: 0.5))
                                .combined(with: .opacity),
                            removal: .scale.combined(with: .opacity)
                        )
                    )
            }
        }
        // WICHTIG: Clipping, damit Bubbles nicht aus der 400x400 Box fliegen,
        // falls die Liste sehr lang wird (optional, sieht oft ohne besser aus)
        // .clipped()
    }
}

#Preview {
    // Mock Data für Preview
    FriendsBubble(particles: [
        UserParticle(user: UserData.ben, targetX: 0, targetY: 0),
        UserParticle(user: UserData.philip, targetX: 60, targetY: 0),
        UserParticle(user: UserData.tim, targetX: -30, targetY: 50),
        UserParticle(user: UserData.mama, targetX: 100, targetY: -50),
        UserParticle(user: UserData.lena, targetX: -100, targetY: 100),
        
    ])
    .frame(width: 400, height: 400)
    .background(Color.gray.opacity(0.2))
}
