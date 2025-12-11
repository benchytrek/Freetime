//
//  InviteView.swift
//  FreetimeRepo
//
//  Created by Ben Chytrek on 09.12.25.
//

import SwiftUI

struct InviteView: View {
    @State private var viewModel = InviteViewModel()
    @State private var selectedInvite: Invite?
    
    var body: some View {
        NavigationStack {
                // --- Sektion 2: Invite Liste ---
                ScrollView {
                    VStack(spacing: 1) {
                        
                        Spacer()
                        
                        Text("Freetime - Invite")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            .padding()
                            .padding(.top, 20)
                            .padding(.bottom, 10)
                            //.background(Color(.systemGray6))
                            //.cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 20)
                            //.animation()
                        
                        Spacer()
                        
                        ForEach(viewModel.InviteList) { invite in
                            InviteCardView(invite: invite)
                                .onTapGesture {
                                    //  angetippte Invite in den State
                                    self.selectedInvite = invite
                                }
                        }
                        
                    
                    .padding(8)
                }
            }
            //.navigationTitle("Free Time")
            .background(Color(.systemGroupedBackground))
            
            // NEU: Der Sheet Modifier
            // Er beobachtet 'selectedInvite'. Sobald es nicht nil ist, geht das Sheet auf.
            .sheet(item: $selectedInvite) { invite in
                InviteDetailView(invite: invite)
                    // WICHTIG: Hier definieren wir die "Snap Points" (Detents)
                    // .fraction(0.35) -> Startet bei ca. 1/3 des Bildschirms
                    // .large -> Kann auf Vollbild hochgezogen werden
                    .presentationDetents([.fraction(0.40), .large])
                    // Zeigt den kleinen grauen Balken oben an, damit User wissen, dass man ziehen kann
                    .presentationDragIndicator(.visible)
                    // Background Material für den modernen "Glass" Look (optional)
                    .presentationBackground(.ultraThinMaterial)
            }
        }
    }
}

#Preview {
    InviteView()
}
