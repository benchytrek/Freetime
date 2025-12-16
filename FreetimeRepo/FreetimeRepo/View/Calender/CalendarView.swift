//
//  CalendarView.swift
//  FreetimeRepo
//
//  Created by Ben Chytrek on 15.12.25.
//

import SwiftUI

struct CalendarView: View {
    // ViewModel nutzen statt @State
    @State private var viewModel = CalendarViewModel()
    @State private var visibleDate: Date = Date()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                // 1. HEADER (Monat & Jahr)
                // Zeigt jetzt das Datum des ersten sichtbaren Tages an (Demo: Dez 2025)
                HStack {
                    if let firstDay = viewModel.days.first?.date {
                        Text(firstDay.formatted(.dateTime.month(.wide).year()))
                            .font(.title2.bold())
                            .foregroundStyle(.primary)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                // 2. HORIZONTAL SNAP LISTE
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 12) {
                        // Wir iterieren jetzt über die angereicherten Tage aus dem ViewModel
                        ForEach(viewModel.days) { day in
                            
                            CalendarDayView(day: day) // Wir übergeben das ganze Day-Objekt
                                
                            // --- SCROLL EFFEKTE ---
                            .containerRelativeFrame(.horizontal, count: 1, spacing: 0) // Fullscreen Card Style? Oder count: 3 lassen
                            .frame(width: 300) // Oder fixe Breite für Snapping
                            .scrollTransition(.interactive, axis: .horizontal) { content, phase in
                                content
                                    .scaleEffect(phase.isIdentity ? 1.0 : 0.92)
                                    .opacity(phase.isIdentity ? 1.0 : 0.6)
                            }
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.viewAligned)
                .contentMargins(.horizontal, 40, for: .scrollContent) // Mehr Rand für Fokus
                
                Spacer()
            }
            .background(Color(.systemBackground))
        }
    }
}

#Preview {
    CalendarView()
}
