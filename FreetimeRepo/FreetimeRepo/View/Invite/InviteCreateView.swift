//
//  InviteCreateView.swift
//  FreetimeRepo
//
//  Created by Ben Chytrek on 13.01.26.
//

import SwiftUI

struct InviteCreateView: View {
    @Environment(\.dismiss) var dismiss
    
    // Nur noch minimaler State für UI
    @State private var title: String = ""
    @FocusState private var isTitleFocused: Bool
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                
                // 1. HINTERGRUND
                Color.black.ignoresSafeArea()
                    .onTapGesture { isTitleFocused = false }
                
                // 2. DIE INTELLIGENTE BUBBLE VIEW
                // Wir übergeben nur den Titel, sie kümmert sich um den Rest.
                FriendsBubble(inputString: title)
                    .offset(y: 120) // Positionierung unter dem Header
                    .allowsHitTesting(false) // Klicks gehen durch zum Hintergrund
                
                // 3. VORDERGRUND (Input Field)
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
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isTitleFocused = true
                }
            }
        }
    }
}

#Preview {
    InviteCreateView()
}
