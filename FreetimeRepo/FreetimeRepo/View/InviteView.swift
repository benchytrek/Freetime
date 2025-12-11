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
    
    // --- SCROLL STEUERUNG ---
    @State private var scrollOffset: CGFloat = 0
    @State private var showCreateSheet = false
    
    // Konfiguration
    private let triggerHeight: CGFloat = 100.0 // Ab hier wird ausgelöst
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    @State private var hasTriggered = false // Verhindert mehrfaches Feuern
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                
                // 1. HINTERGRUND & ACTION INDICATOR
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                // Der Indicator, der hinter der Liste sichtbar wird
                if scrollOffset > 0 {
                    ZStack {
                        // Dynamischer Kreis
                        Circle()
                            .fill(scrollOffset > triggerHeight ? Color.blue : Color.gray.opacity(0.3))
                            .frame(width: 45, height: 45)
                            .shadow(radius: 5)
                            .animation(.snappy, value: scrollOffset > triggerHeight)
                        
                        // Icon wechselt
                        Image(systemName: scrollOffset > triggerHeight ? "plus" : "arrow.down")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(scrollOffset > triggerHeight ? .white : .secondary)
                            .contentTransition(.symbolEffect(.replace))
                    }
                    // Positioniert sich dynamisch basierend auf dem Pull
                    .offset(y: 60 + (scrollOffset * 0.5))
                    .opacity(Double(min(scrollOffset / 60.0, 1.0)))
                    .scaleEffect(scrollOffset > triggerHeight ? 1.2 : 1.0)
                }
                
                // 2. SCROLLVIEW MIT MESSUNG
                ScrollView {
                    VStack(spacing: 0) {
                        
                        // --- MESS-SENSOR (KORRIGIERT) ---
                        // Wir platzieren ihn als Overlay über einem unsichtbaren Frame ganz oben.
                        // Das ist robuster als GeometryReader direkt im Flow.
                        Color.clear.frame(height: 0)
                            .background(
                                GeometryReader { proxy in
                                    Color.clear.preference(
                                        key: ScrollOffsetKey.self,
                                        value: proxy.frame(in: .named("scrollSpace")).minY
                                    )
                                }
                            )
                        
                        
                        // Header Area
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
                        .padding(.top, 60)
                        
                        // White Space (Apple Style) - Optional, falls du den Abstand willst
                        Color.clear.frame(height: 40)
                        
                        // Die eigentliche Liste
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.InviteList) { invite in
                                InviteCardView(invite: invite)
                                    .onTapGesture {
                                        self.selectedInvite = invite
                                    }
                                    .padding(.horizontal, 16)
                            }
                        }
                        .padding(.bottom, 50)
                    }
                }
                // WICHTIG: Koordinatenraum benennen
                .coordinateSpace(name: "scrollSpace")
                // Auf Änderungen des ScrollOffsets reagieren
                .onPreferenceChange(ScrollOffsetKey.self) { offset in
                    handleScrollUpdate(offset: offset)
                }
                .scrollIndicators(.hidden)
            }
            
            // --- SHEETS ---
            
            // Detail Sheet
            .sheet(item: $selectedInvite) { invite in
                InviteDetailView(invite: invite)
                    .presentationDetents([.fraction(0.40), .large])
                    .presentationDragIndicator(.visible)
                    .presentationBackground(.ultraThinMaterial)
            }
            
            // Create Sheet (Getriggert durch Pull)
            .sheet(isPresented: $showCreateSheet) {
                InviteCreateView()
            }
        }
    }
    
    // MARK: - Logik
    private func handleScrollUpdate(offset: CGFloat) {
        self.scrollOffset = offset
        
        // DEBUG: Ausgabe in die Konsole
        if offset > 0 {
            print("👇 Pull Offset: \(Int(offset)) / Trigger: \(Int(triggerHeight))")
        }
        
        // Trigger Logik
        if offset > triggerHeight {
            if !hasTriggered && !showCreateSheet {
                print("✅ TRIGGER ACTIVATED! Opening Sheet...")
                // Aktion auslösen
                feedbackGenerator.impactOccurred()
                hasTriggered = true
                
                // Sheet öffnen (leicht verzögert für besseres Gefühl)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    showCreateSheet = true
                }
            }
        } else {
            // Reset Trigger, wenn man weit genug zurückscrollt
            if offset < 50 {
                if hasTriggered { print("🔄 Trigger Reset") }
                hasTriggered = false
            }
        }
    }
}

// MARK: - Preference Key Helper
struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue() // Wir nehmen einfach den neuesten Wert
    }
}

#Preview {
    InviteView()
}
