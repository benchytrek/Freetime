//
//  CalendarDateRow.swift
//  FreetimeRepo
//
//  Created by Ben Chytrek on 15.12.25.
//

import SwiftUI

struct CalendarDateRow: View {
    let day: CalendarDay
    
    var body: some View {
        VStack(spacing: 6) {
            // Wochentag (z.B. MO)
            Text(day.weekday)
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
            
            // Tag-Nummer (z.B. 15)
            ZStack {
                if day.isToday {
                    Circle()
                        .fill(Color.red) // Apple nutzt Rot für "Heute"
                        .frame(width: 32, height: 32)
                }
                
                Text(day.dayNumber)
                    .font(.title3) // Etwas größer für bessere Lesbarkeit
                    .fontWeight(day.isToday ? .bold : .semibold)
                    .foregroundStyle(day.isToday ? .white : .primary)
            }
        }
        .frame(width: 50) // Breite an TimeColumn angepasst (ca.)
        .frame(height: 60) // Fixe Höhe für sauberes Layout
    }
}

#Preview {
    HStack(spacing: 20) {
        // Beispiel 1: Heute
        CalendarDateRow(day: CalendarDay(
            id: "today",
            dayNumber: "18",
            weekday: "DO",
            fullDateId: "2025-12-18",
            date: Date(),
            isToday: true,
            timeSlots: [],
            events: []
        ))
        
        // Beispiel 2: Anderer Tag
        CalendarDateRow(day: CalendarDay(
            id: "tomorrow",
            dayNumber: "19",
            weekday: "FR",
            fullDateId: "2025-12-19",
            date: Date().addingTimeInterval(86400),
            isToday: false,
            timeSlots: [],
            events: []
        ))
    }
    .padding()
}
