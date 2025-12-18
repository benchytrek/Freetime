//
//  CalendarView.swift
//  FreetimeRepo
//
//  Refactored by Senior Dev Partner on 18.12.25.
//

import SwiftUI

struct CalendarView: View {
    // Zugriff auf die Daten
    @State private var viewModel = CalendarViewModel()
    
    // Wir merken uns, welcher Tag gerade in der Mitte (fokussiert) ist
    @State private var currentDayID: UUID?
    
    // Header View (ausgelagert für Übersichtlichkeit)
    var header: some View {
        Text("Calendar")
            .font(Font.largeTitle.bold())
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            .frame(maxWidth: .infinity, alignment: .leading) // Links bündig
            .padding(.horizontal)
            .padding(.top, 10)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            // --- HEADER ---
            header
            
            // --- MAIN CONTENT ---
            ZStack(alignment: .topLeading) {
                
                // 1. DER SCROLLVIEW READER
                ScrollViewReader { scrollProxy in
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 0) {
                            
                            // Platzhalter für TimeColumn
                            Color.clear.frame(width: 50)
                            
                            ForEach(viewModel.days) { day in
                                VStack(spacing: 12) {
                                    
                                    // --- NEUE DATE ROW ---
                                    // Hier ist sie: Bewegt sich mit, steht aber oben drüber
                                    CalendarDateRow(day: day)
                                        .id(day.id) // ID für ScrollTo
                                    
                                    // --- DAY VIEW (Timeline) ---
                                    CalendarDayView(day: day)
                                        .frame(width: 100)
                                        // Animationen NUR für die Timeline (wenn gewünscht)
                                        // oder für beide, damit Layout konsistent bleibt.
                                        // Hier wenden wir den Effekt auf den Streifen an.
                                }
                                .padding(.horizontal, 6)
                                
                                // --- ANIMATIONEN (Auf den ganzen Spalten-Container) ---
                                .scrollTransition(.interactive, axis: .horizontal) { view, position in
                                    view
                                        .opacity(position.value < -0.3 ? 0.3 : 1.0)
                                        .scaleEffect(position.value < -0.3 ? 0.8 : 1.0)
                                        .scaleEffect(position.value > 0.3 ? 0.5 : (position.value < -0.3 ? 0.8 : 1.0))
                                        .offset(x: position.value > 0.3 ? -30 : 0)
                                }
                                // --- ON TAP ---
                                .onTapGesture {
                                    guard day.id != currentDayID else { return }
                                    
                                    withAnimation(.snappy) {
                                        scrollProxy.scrollTo(day.id, anchor: .center)
                                        currentDayID = day.id
                                    }
                                }
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .scrollTargetBehavior(.viewAligned)
                    .scrollPosition(id: $currentDayID)
                    .contentMargins(.horizontal, 40, for: .scrollContent)
                    .frame(height: 600)
                }
                
                // 2. TIME COLUMN (Fixiertes Overlay links)
                VStack {
                    // Spacer, damit die Zeitspalte erst unter dem Datum beginnt
                    // ca. Headerhöhe (DateRow ist ca 50-60 hoch)
                    Color.clear.frame(height: 60)
                    
                    CalendarTimeColum()
                        .background(
                            LinearGradient(
                                colors: [Color(.systemBackground), Color(.systemBackground).opacity(0)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                }
                .frame(width: 50)
                .allowsHitTesting(false)
            }
        }
        .onAppear {
            if viewModel.days.isEmpty { viewModel.loadData() }
        }
        .onChange(of: viewModel.days) { _, newDays in
            if currentDayID == nil, let firstToday = newDays.first(where: { $0.isToday }) {
                currentDayID = firstToday.id
            } else if currentDayID == nil {
                currentDayID = newDays.first?.id
            }
        }
    }
}

// MARK: - Subcomponents

// Deine ausgelagerte Date Row (für EINEN Tag)


#Preview {
    CalendarView()
}
