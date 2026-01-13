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
    
    // State für die Partikel
    @State private var particles: [UserParticle] = []
    
    // Layout Mathe Konstanten
    let spacing: CGFloat = 65
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                
                // 1. HINTERGRUND
                Color.black.ignoresSafeArea()
                    .onTapGesture { isTitleFocused = false }
                
                // 2. PARTIKEL CONTAINER (400x400 Box)
                // Positioniert unter dem Header
                FriendsBubble(particles: particles)
                    .frame(width: 400, height: 400)
                    // Verschiebt die ganze Box visuell etwas nach unten, damit die Mitte passt
                    .offset(y: 150)
                    .allowsHitTesting(false) // Klicks gehen durch (zum Dismissen der Tastatur)
                
                // 3. VORDERGRUND (Input Field Balken)
                VStack(spacing: 0) {
                    
                    // TITEL EINGABE
                    ZStack(alignment: .center) {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.ultraThinMaterial)
                            .frame(width: 300, height: 60)
                            .shadow(color: .white.opacity(0.15), radius: 10, x: 0, y: 5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(.white.opacity(0.2), lineWidth: 1)
                            )
                        
                        TextField("Was geht ab?", text: $title)
                            .font(.system(size: 20, weight: .bold))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.white)
                            .frame(width: 300)
                            .focused($isTitleFocused)
                    }
                    .padding(.top, 60)
                    .zIndex(100)
                    
                    Spacer()
                }
            }
            .navigationTitle("New Invite")
            .navigationBarTitleDisplayMode(.inline)
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
            // Tipp-Logik
            .onChange(of: title) { oldValue, newValue in
                handleTyping(old: oldValue, new: newValue)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isTitleFocused = true
                }
            }
        }
    }
    
    // MARK: - LOGIC (Phyllotaxis)
    
    func handleTyping(old: String, new: String) {
        if new.count > old.count {
            addParticle(index: new.count - 1)
        } else if new.count < old.count {
            removeParticle()
        }
    }
    
    func addParticle(index: Int) {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
            let user = UserData.partyPeople[index % UserData.partyPeople.count]
            
            // Mathe für Grid-Position relativ zur Mitte (0,0)
            let angle = Double(index) * 2.39996 // Goldener Winkel
            let radius = spacing * CGFloat(sqrt(Double(index)))
            
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

#Preview {
    InviteCreateView()
}
