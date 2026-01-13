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
    
    // Sheet State für "Neues Invite erstellen"
    @State private var showCreateSheet = false
    
    // Konfiguration für den Pull-Trigger
    let triggerThreshold: CGFloat = 100.0
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 1. HINTERGRUND
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                // 2. SCROLLVIEW (Clean)
                ScrollView {
                    // Der "Tracker" muss IN der ScrollView ganz oben liegen, daher ZStack
                    ZStack(alignment: .top) {
                        
                        // A) Unsichtbarer Sensor zum Messen der Y-Position
                        GeometryReader { proxy -> Color in
                            let minY = proxy.frame(in: .named("pullToCreate")).minY
                            
                            // Logik-Check asynchron (verhindert UI-Warnungen)
                            DispatchQueue.main.async {
                                handleScrollOffset(minY)
                            }
                            
                            return Color.clear
                        }
                        .frame(height: 0) // Nimmt keinen Platz weg
                        
                        // B) Der eigentliche Inhalt
                        VStack(spacing: 0) {
                            
                            // --- HEADER AREA ---
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Freetime")
                                    .font(.system(size: 34, weight: .bold))
                                    .foregroundStyle(.primary)
                                
                                Text("Invites")
                                    .font(.title3.bold())
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                            .padding(.top, 60) // Platz nach oben
                            
                            // White Space
                            Color.clear.frame(height: 40)
                            
                            // --- INVITE LISTE ---
                            LazyVStack(spacing: 16) {
                                ForEach(viewModel.InviteList) { invite in
                                    InviteCardView(invite: invite)
                                        .onTapGesture {
                                            self.selectedInvite = invite
                                        }
                                        .padding(.horizontal, 16)
                                }
                            }
                            .padding(.bottom, 50) // Padding unten
                        }
                    }
                }
                .scrollIndicators(.hidden)
                // WICHTIG: Koordinatenraum definieren für den Sensor
                .coordinateSpace(name: "pullToCreate")
            }
            // --- SHEETS ---
            // 1. Detail-Ansicht (Invite anschauen)
            .sheet(item: $selectedInvite) { invite in
                InviteDetailView(invite: invite)
                    .presentationDetents([.fraction(0.40), .large])
                    .presentationDragIndicator(.visible)
                    .presentationBackground(.ultraThinMaterial)
            }
            // ... in InviteView.swift ...
                        
            // Create-Sheet (durch Swipe ausgelöst)
            .sheet(isPresented: $showCreateSheet) {
                // WICHTIG: Wir geben unser existierendes ViewModel weiter!
                InviteCreateView()
            }
        }
    }
    
    // MARK: - Logik
    func handleScrollOffset(_ offset: CGFloat) {
        // Trigger-Logik: Wenn Offset > 100px und Sheet noch nicht offen
        if offset > triggerThreshold && !showCreateSheet {
            
            // Haptic Feedback (Vibration) für cooles Feeling
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
            
            // Sheet öffnen
            showCreateSheet = true
        }
    }
}

#Preview {
    InviteView()
}
