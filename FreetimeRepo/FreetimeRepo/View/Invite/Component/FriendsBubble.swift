//
//  FriendsBubble.swift
//  FreetimeRepo
//
//  Created by Ben Chytrek on 14.01.26.
//

import SwiftUI

struct FriendsBubble: View {
    var inputString: String
    
    // NEU: Binding empfangen (Verbindung nach oben)
    @Binding var selectedUserIds: Set<UUID>
    
    @State private var items: [BubbleItem] = []
    @State private var validSlots: [CGPoint] = []
    
    private let containerSize: CGFloat = 300
    private let iconSize: CGFloat = 50
    private let spacing: CGFloat = 8
    
    // Model: Kein 'isSelected' mehr hier drin!
    struct BubbleItem: Identifiable {
        let id = UUID() // Interne ID für ForEach
        let user: User
        let index: Int
        let position: CGPoint
        let startOffset: CGSize
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            
            ForEach(items) { item in
                // LIVE CHECK: Ist dieser User im Set?
                let isSelected = selectedUserIds.contains(item.user.id)
                
                UserBubble(user: item.user, size: iconSize, isSelected: isSelected)
                    .position(item.position)
                    
                    // TAP GESTURE: Ändert das Binding
                    .onTapGesture {
                        toggleSelection(for: item.user.id)
                    }
                    
                    .transition(.asymmetric(
                        insertion: .offset(item.startOffset).combined(with: .opacity),
                        removal: .scale
                    ))
                    // Wenn ausgewählt, hol es visuell nach vorne
                    .zIndex(isSelected ? 100 : Double(items.count - item.index))
            }
        }
        .frame(width: containerSize, height: containerSize)
        .overlay(
            LinearGradient(
                stops: [
                    .init(color: .clear, location: 0.8),
                    .init(color: Color(.systemBackground), location: 1.0)
                ],
                startPoint: .top,
                endPoint: .bottom
            ),
            alignment: .bottom
        )
        .onAppear {
            self.validSlots = generateOvalSlots()
            fillForTesting()
        }
        .onChange(of: inputString) { oldValue, newValue in
            updateBubbles(old: oldValue, new: newValue)
        }
    }
    
    // MARK: - Logic
    
    private func toggleSelection(for userId: UUID) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        // Hier ändern wir direkt das Binding -> Update geht hoch zur InviteCreateView
        if selectedUserIds.contains(userId) {
            selectedUserIds.remove(userId)
        } else {
            selectedUserIds.insert(userId)
        }
    }
    
    private func fillForTesting() {
        // Test-Daten füllen
        for i in 0..<15 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.05) {
                addBubble(index: i)
            }
        }
    }
    
    private func updateBubbles(old: String, new: String) {
        if new.count > old.count {
            addBubble(index: items.count)
        } else if new.count < old.count {
            removeBubble()
        }
    }
    
    private func addBubble(index: Int) {
        guard index < validSlots.count else { return }
        
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
            let user = UserData.partyPeople[index % UserData.partyPeople.count]
            let targetPos = validSlots[index]
            
            let randomStartX = CGFloat.random(in: -50...(containerSize + 50))
            let randomStartY = CGFloat.random(in: -500...(-100))
            
            let offset = CGSize(
                width: randomStartX - targetPos.x,
                height: randomStartY - targetPos.y
            )
            
            let newItem = BubbleItem(
                user: user,
                index: index,
                position: targetPos,
                startOffset: offset
            )
            items.append(newItem)
        }
    }
    
    private func removeBubble() {
        withAnimation(.easeOut(duration: 0.2)) {
            if !items.isEmpty {
                items.removeLast()
            }
        }
    }
    
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
                if row % 2 != 0 { x += hexWidth / 2 }
                
                let finalX = x + 15
                let finalY = y + 20
                let dx = finalX - centerX
                let dy = finalY - centerY
                
                if sqrt(dx*dx + dy*dy) < radius {
                    slots.append(CGPoint(x: finalX, y: finalY))
                }
            }
        }
        return slots.sorted {
            if abs($0.y - $1.y) > 10 { return $0.y < $1.y }
            else { return $0.x < $1.x }
        }
    }
}
