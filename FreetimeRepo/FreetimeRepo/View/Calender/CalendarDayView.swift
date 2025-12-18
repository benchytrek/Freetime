//
//  CalendarDayView.swift
//  FreetimeRepo
//
//  Created by Ben Chytrek on 15.12.25.
//

import SwiftUI

struct CalendarDayView: View {
    // DAS HIER hat gefehlt. Jetzt kann die View Daten empfangen.
    let day: CalendarDay
    
    // --- KONFIGURATION ---
    // Unsere Timeline geht von 8:00 bis 22:00 Uhr
    private let startHour: Double = 8
    private let endHour: Double = 22
    private let hourHeight: CGFloat = 60 // Ein Stunde ist 60px hoch
    
    var body: some View {
        ZStack {
            // Hintergrund
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.teal)
                .frame(width: 100, height: 600) // Angepasst an die Höhe in CalendarView (500)
            
            // Optional: Einfacher Text um zu sehen welcher Tag es ist
            VStack {
                Text(day.weekday)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(day.dayNumber)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
        }
    }
}

// MARK: - Subviews & Helper

#Preview {
    // Mock Data für Preview
    CalendarDayView(day: CalendarDay(
        id: UUID(),
        dayNumber: "18",
        weekday: "DO",
        fullDateId: "2025-12-18",
        date: Date(),
        isToday: true,
        timeSlots: [],
        events: []
    ))
    .padding()
}
