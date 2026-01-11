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
        HStack {
            VStack(alignment: .leading) {
                Text(Date().formatted(.dateTime.month()))
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                
                Text("Kalender") // Oder dynamisch Monat
                    .font(.largeTitle.bold())
                    .shadow(color: Color.gray.opacity(0.5), radius: 6, x: 8, y: 8)
            }
            Spacer()
            
            // Profilbild Platzhalter (Apple Style oben rechts)
            Circle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 36, height: 36)
                .overlay(Image(systemName: "person.fill").foregroundStyle(.gray))
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            // --- HEADER ---
            header
            
            Spacer()
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
                                    
                                    // --- DATE ROW (Ausgelagert in eigene Datei) ---
                                    CalendarDateRow(day: day)
                                        .id(day.id) // ID für ScrollTo
                                    
                                    // --- DAY VIEW (Timeline) ---
                                    CalendarDayView(day: day)
                                        .frame(width: 100)
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
                    // ca. Headerhöhe (DateRow ist ca 60 hoch)
                    Color.clear.frame(height: 70)
                    
                    CalendarTimeColum()
                        
                }
                .frame(width: 50)
                .allowsHitTesting(false)
            }
            // tods list unten
            Rectangle()
                .fill(Color(.orange))
                .opacity(0.5)
                .blur(radius: 10)
                .frame(width: 400, height: 10)
                .padding(10)
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

#Preview {
    CalendarView()
}
