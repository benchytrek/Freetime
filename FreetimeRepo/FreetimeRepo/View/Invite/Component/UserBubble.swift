//
//  UserBubble.swift
//  FreetimeRepo
//
//  Created by Ben Chytrek on 14.01.26.
//

import SwiftUI

struct UserBubble: View {
    let user: User
    let size: CGFloat
    var isSelected: Bool = false
    
    @State private var isWobbling = false
    
    // Farbe logik: Grün bei Auswahl
    var currentColor: Color {
        if isSelected { return .green }
        let colors: [Color] = [.blue, .purple, .pink, .cyan, .mint, .orange, .indigo]
        return colors[abs(user.name.hashValue) % colors.count]
    }
    
    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                // Glow
                Circle()
                    .fill(currentColor)
                    .frame(width: size, height: size)
                    .blur(radius: isSelected ? 10 : 8)
                    .opacity(isSelected ? 0.8 : 0.6)
                
                // Körper
                Circle()
                    .fill(LinearGradient(colors: [currentColor.opacity(0.9), currentColor.opacity(0.7)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: size, height: size)
                    .overlay(Circle().stroke(.white, lineWidth: isSelected ? 3 : 1).opacity(isSelected ? 1 : 0.4))
                
                // Icon
                Image(systemName: isSelected ? "checkmark" : "person.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: size * 0.45)
                    .foregroundStyle(.white)
                    .contentTransition(.symbolEffect(.replace))
            }
            .scaleEffect(isSelected ? 1.1 : 1.0)
            
            // Name
            Text(user.name)
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(.primary)
                .shadow(color: .white.opacity(0.8), radius: 2)
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
        // Waber-Animation
        .offset(x: isWobbling ? CGFloat.random(in: -1...1) : 0, y: isWobbling ? CGFloat.random(in: -1...1) : 0)
        .onAppear {
            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) { isWobbling = true }
        }
    }
}
