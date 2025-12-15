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
    @State private var scrollOffsetTop: CGFloat = 0
    @State private var scrollOffsetBottom: CGFloat = 0
    @State private var scrollViewHeight: CGFloat = 0
    
    @State private var showCreateSheet = false
    
    // Konfiguration
    private let triggerHeight: CGFloat = 100.0 // Ab hier wird ausgelöst
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    @State private var hasTriggered = false // Verhindert mehrfaches Feuern
    
    var body: some View {
        NavigationStack {
            // GeometryReader, um die Screen-Höhe für den Bottom-Pull zu kennen
            GeometryReader { geo in
                ZStack(alignment: .top) {
                    
                    // 1. HINTERGRUND
                    Color(.systemGroupedBackground)
                        .ignoresSafeArea()
                    
                    // 2a. TOP ACTION INDICATOR (Pull Down)
                    if scrollOffsetTop > 0 {
                        ActionIndicator(
                            offset: scrollOffsetTop,
                            trigger: triggerHeight,
                            iconName: "arrow.down",
                            alignment: .top
                        )
                    }
                    
                    // 2b. BOTTOM ACTION INDICATOR (Pull Up)
                    // Berechnung: ScreenHöhe - Unterkante des Inhalts = Zieh-Distanz
                    let bottomPullDistance = scrollViewHeight - scrollOffsetBottom
                    
                    if bottomPullDistance > 0 {
                        ActionIndicator(
                            offset: bottomPullDistance,
                            trigger: triggerHeight,
                            iconName: "arrow.up",
                            alignment: .bottom
                        )
                        // Positionierung am unteren Rand
                        .position(x: geo.size.width / 2, y: geo.size.height - (60 + (bottomPullDistance * 0.5)))
                    }
                    
                    // 3. SCROLLVIEW MIT MESSUNG
                    ScrollView {
                        VStack(spacing: 0) {
                            
                            // --- TOP SENSOR ---
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
                            
                            // White Space
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
                                
                                // --- BOTTOM SENSOR ---
                                // Sitzt ganz am Ende der Liste
                                Color.clear.frame(height: 0)
                                    .background(
                                        GeometryReader { proxy in
                                            Color.clear.preference(
                                                key: BottomScrollOffsetKey.self,
                                                value: proxy.frame(in: .named("scrollSpace")).maxY
                                            )
                                        }
                                    )
                            }
                            .padding(.bottom, 50)
                            
                            // Mindesthöhe garantieren, damit Scrollen immer möglich ist (auch bei leerer Liste)
                            .frame(minHeight: geo.size.height)
                        }
                    }
                    // WICHTIG: Koordinatenraum benennen
                    .coordinateSpace(name: "scrollSpace")
                    .scrollIndicators(.hidden)
                    
                    // --- PREFERENCE CHANGE HANDLERS ---
                    
                    // 1. Top Pull
                    .onPreferenceChange(ScrollOffsetKey.self) { value in
                        self.scrollOffsetTop = value
                        checkTrigger(pullDistance: value)
                    }
                    
                    // 2. Bottom Pull
                    .onPreferenceChange(BottomScrollOffsetKey.self) { value in
                        self.scrollOffsetBottom = value
                        let distance = geo.size.height - value
                        checkTrigger(pullDistance: distance)
                    }
                }
                // Höhe speichern für Berechnungen
                .onAppear { self.scrollViewHeight = geo.size.height }
                .onChange(of: geo.size.height) { old, new in self.scrollViewHeight = new }
            }
            
            // --- SHEETS ---
            .sheet(item: $selectedInvite) { invite in
                InviteDetailView(invite: invite)
                    .presentationDetents([.fraction(0.40), .large])
                    .presentationDragIndicator(.visible)
                    .presentationBackground(.ultraThinMaterial)
            }
            .sheet(isPresented: $showCreateSheet) {
                InviteCreateView()
            }
        }
    }
    
    // MARK: - Logik
    
    // Eine zentrale Funktion, die prüft, ob weit genug gezogen wurde
    private func checkTrigger(pullDistance: CGFloat) {
        // Trigger Logik
        if pullDistance > triggerHeight {
            if !hasTriggered && !showCreateSheet {
                print("✅ TRIGGER ACTIVATED! (Distance: \(Int(pullDistance)))")
                feedbackGenerator.impactOccurred()
                hasTriggered = true
                
                // Sheet öffnen
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    showCreateSheet = true
                }
            }
        } else {
            // Reset Trigger, wenn man weit genug zurückscrollt
            if pullDistance < 50 {
                if hasTriggered { hasTriggered = false }
            }
        }
    }
}

// MARK: - Helper Views & Keys

// Wiederverwendbarer Indikator für Oben und Unten
struct ActionIndicator: View {
    let offset: CGFloat
    let trigger: CGFloat
    let iconName: String
    let alignment: VerticalAlignment
    
    var body: some View {
        ZStack {
            Circle()
                .fill(offset > trigger ? Color.blue : Color.gray.opacity(0.3))
                .frame(width: 45, height: 45)
                .shadow(radius: 5)
                .animation(.snappy, value: offset > trigger)
            
            Image(systemName: offset > trigger ? "plus" : iconName)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(offset > trigger ? .white : .secondary)
                .contentTransition(.symbolEffect(.replace))
        }
        // Top fährt von oben rein (Offset + 60), Bottom wird über .position gesteuert (Offset: 0)
        .offset(y: alignment == .top ? (60 + (offset * 0.5)) : 0)
        .opacity(Double(min(offset / 60.0, 1.0)))
        .scaleEffect(offset > trigger ? 1.2 : 1.0)
    }
}

// Preference Key für OBEN
struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// Preference Key für UNTEN
struct BottomScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = .infinity // Default unendlich
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
    InviteView()
}
