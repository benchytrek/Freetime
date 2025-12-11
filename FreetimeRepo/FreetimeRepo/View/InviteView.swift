//
//  InviteView.swift
//  FreetimeRepo
//
//  Created by Ben Chytrek on 09.12.25.
//

import SwiftUI

struct InviteView: View {
    // Hier verbinden wir das ViewModel
    // Das ViewModel lädt im init() bereits deine Dummy-Daten (Pizza & Gym)
    @State private var viewModel = InviteViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) { // Spacing auf 0, wir regeln Abstände mit Padding
                
                // --- Sektion 1: User Bubbles (Horizontal) ---
                // Bleibt wie gehabt, sieht super aus
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(viewModel.UserList) { user in
                            VStack {
                                Circle()
                                    .fill(Color.blue.opacity(0.1)) // Leichterer Blue Tone für Clean Look
                                    .frame(width: 60, height: 60)
                                    .overlay(
                                        Text(user.name.prefix(1))
                                            .font(.title3.bold())
                                            .foregroundStyle(.blue)
                                    )
                                
                                Text(user.name)
                                    .font(.caption)
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                    .padding() // Padding rundherum für die ScrollView
                }
                
                Divider()
                    .padding(.bottom, 10)
                
                // --- Sektion 2: Invite Liste (Vertikal) ---
                // Hier ist die Änderung: ScrollView + ForEach für die Liste
                ScrollView {
                    VStack(spacing: 16) { // Abstand zwischen den Karten
                        
                        // Wir gehen durch ALLE Invites im ViewModel
                        ForEach(viewModel.InviteList) { invite in
                            InviteCardView(invite: invite)
                        }
                        
                    }
                    .padding() // Abstand zum Bildschirmrand (Links/Rechts/Unten)
                }
            }
            .navigationTitle("Free Time")
            .background(Color(.systemGroupedBackground)) // Grauer Hintergrund für die App, damit die weißen Karten poppen
        }
    }
}

#Preview {
    InviteView()
}
