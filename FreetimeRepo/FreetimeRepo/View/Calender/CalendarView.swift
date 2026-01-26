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
    
    // Wir merken uns, welcher Tag gerade links fokussiert ist
    @State private var currentDayID: String?
               
    // Header View
    var header: some View {
        HStack {
            VStack(alignment: .leading) {
                // Dynamisches Datum basierend auf dem sichtbaren Tag
                Text(activeDateString)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                    .contentTransition(.numericText())
                
                Text("Kalender")
                    .font(.largeTitle.bold())
                    .shadow(color: Color.gray.opacity(0.5), radius: 6, x: 8, y: 8)
            }
            Spacer()
            
            // Profilbild Platzhalter
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
                
                // 1. SCROLLVIEW
                ScrollViewReader { scrollProxy in
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 0) {
                            
                            // HINWEIS: Spacer entfernt. Wir nutzen contentMargins für sauberes Snapping.
                            
                            ForEach(viewModel.days) { day in
                                VStack(spacing: 12) {
                                    
                                    // --- DATE ROW ---
                                    CalendarDateRow(day: day)
                                        .id(day.id) // Wichtig für ScrollPosition
                                    
                                    // --- DAY VIEW ---
                                    CalendarDayView(day: day)
                                        .frame(width: 100)
                                }
                                .padding(.horizontal, 6)
                                
                                // --- ANIMATIONEN ---
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
                                        currentDayID = day.id
                                    }
                                }
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .scrollTargetBehavior(.viewAligned)
                    // LOGIK: anchor: .leading sorgt dafür, dass der Tag LINKS einrastet
                    .scrollPosition(id: $currentDayID, anchor: .leading)
                    // LOGIK: 50pt Margin links reservieren Platz für die TimeColumn
                    .contentMargins(.leading, 50, for: .scrollContent)
                    .contentMargins(.trailing, 40, for: .scrollContent)
                    .frame(height: 600)
                }
                
                // 2. TIME COLUMN (Fixiertes Overlay links)
                VStack {
                    Color.clear.frame(height: 70) // Platzhalter für Header-Abstand
                    CalendarTimeColum()
                }
                .frame(width: 50)
                .allowsHitTesting(false)
            }
            
            // Deko Element unten
            Rectangle()
                .fill(Color(.orange))
                .opacity(0.5)
                .blur(radius: 10)
                .frame(width: 400, height: 10)
                .padding(10)
        }
        .onAppear {
            if viewModel.days.isEmpty { viewModel.loadData() }
            
            // WICHTIG: Beim Start direkt zu "Heute" springen
            if currentDayID == nil {
                currentDayID = viewModel.todayId
            }
        }
    }
    
    // Helper für dynamischen Header-Text
    private var activeDateString: String {
        if let id = currentDayID, let day = viewModel.days.first(where: { $0.id == id }) {
            return day.date.formatted(.dateTime.month(.wide).year())
        }
        return Date().formatted(.dateTime.month(.wide).year())
    }
}

#Preview {
    CalendarView()
}
