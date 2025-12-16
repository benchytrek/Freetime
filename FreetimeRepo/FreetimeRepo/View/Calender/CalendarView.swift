//
//  CalendarView.swift
//  FreetimeRepo
//
//  Created by Ben Chytrek on 15.12.25.
//

import SwiftUI

struct CalendarView: View {
    // MARK: - Properties
    
    @State private var days: [Date] = {
        let calendar = Calendar.current
        let today = Date()
        return (0..<30).compactMap { offset in
            calendar.date(byAdding: .day, value: offset, to: today)
        }
    }()
    
    // Für den Header (Monatsanzeige)
    @State private var visibleDate: Date = Date()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                
                
                // 1. HEADER (Monat & Jahr)
                HStack {
                    Text(visibleDate.formatted(.dateTime.month(.wide).year()))
                        .font(.title2.bold())
                        .foregroundStyle(.primary)
                    
                    Image(systemName: "chevron.right")
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                
                
                
                HStack {
                    //CalendarDateRow(date: Date(), isToday: true)

                }.frame(height: 20)
                
                // 2. HORIZONTAL SNAP LISTE
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 12) {
                        ForEach(days, id: \.self) { date in
                            
                            // HIER ist jetzt deine neue View im Einsatz:
                            CalendarDayView(
                                date: date,
                                isToday: Calendar.current.isDateInToday(date)
                            )
                            // --- SCROLL EFFEKTE & SNAP ---
                            .containerRelativeFrame(.horizontal, count: 3, spacing: 12)
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
                .contentMargins(.horizontal, 20, for: .scrollContent)
                
                Spacer()
            }
            .background(Color(.systemBackground))
        }
    }
}

#Preview {
    CalendarView()
}
