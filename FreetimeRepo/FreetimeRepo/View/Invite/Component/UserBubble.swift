//
//  UserBubble.swift
//  FreetimeRepo
//
//  Created by Ben Chytrek on 13.01.26.
//

import SwiftUI

struct UserBubble: View {
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
    UserBubble(user: User.init(id: UUID(), name: "ben"), size: 100)
}
