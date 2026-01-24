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
    
    // NEU: Die "Source of Truth" für die Auswahl
    @State private var selectedUserIds: Set<UUID> = []
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                
                // 1. HINTERGRUND
                Color(.systemBackground)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isTitleFocused = false
                    }
                
                // 2. BUBBLES
                // WICHTIG: Wir übergeben das Binding ($selectedUserIds)
                FriendsBubble(inputString: title, selectedUserIds: $selectedUserIds)
                    .offset(y: 120)
                
                // 3. VORDERGRUND (Input Field)
                VStack(spacing: 0) {
                    
                    // INPUT FELD
                    ZStack(alignment: .center) {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.ultraThinMaterial)
                            .frame(width: 300, height: 60)
                            .shadow(color: Color.primary.opacity(0.1), radius: 10, x: 0, y: 5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                            )
                        
                        TextField("Was geht ab?", text: $title)
                            .font(.system(size: 20, weight: .bold))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.primary)
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
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") { dismiss() }
                        .foregroundStyle(.primary)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Erstellen") {
                        print("Erstelle Invite mit: \(selectedUserIds)")
                        dismiss()
                    }
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
