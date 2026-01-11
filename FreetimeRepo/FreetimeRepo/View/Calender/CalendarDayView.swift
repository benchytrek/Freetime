//
//  CalendarDayView.swift
//  FreetimeRepo
//
//  Created by Ben Chytrek on 15.12.25.
//

import SwiftUI

struct CalendarDayView: View {
    let day: CalendarDay
    
    // --- KONFIGURATION ---
    // Unsere Timeline geht von 8:00 bis 22:00 Uhr (14 Stunden)
    private let startHour: Double = 8
    private let endHour: Double = 22
    
    // UI-Vorgabe: Die Box soll fix 500 hoch sein
    private let totalHeight: CGFloat = 500
    
    // Dynamische Berechnung: Wie hoch ist eine Stunde, damit alles in 500px passt?
    // 500 / (22 - 8) = 500 / 14 = ca. 35.7 px pro Stunde
    private var hourHeight: CGFloat {
        return totalHeight / (endHour - startHour)
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            // 1. Hintergrund (Die "Spur" für den Tag)
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.teal.opacity(0.1)) // Etwas transparenter für besseren Kontrast
                .frame(width: 100, height: totalHeight) // Fixe Höhe 500
            
            // 2. Events positionieren
            ZStack(alignment: .top) {
                ForEach(day.events) { event in
                    // Wir müssen dem CalendarInvite sagen, wie hoch eine Stunde ist,
                    // damit die Box-Größe zur neuen Skalierung passt.
                    // Da CalendarInvite aktuell hardcoded * 60 rechnet, müssen wir die Höhe hier überschreiben
                    // oder CalendarInvite anpassen.
                    // SAUBERER WEG: Wir setzen den frame hier basierend auf der neuen hourHeight.
                    
                    CalendarInvite(invite: event)
                        // Überschreibe den Frame vom Invite, damit er zur Skalierung passt
                        .frame(width: 90, height: CGFloat(event.duration) * hourHeight)
                        .position(
                            x: 50, // Mitte der 100px breiten Spalte
                            y: positionFor(event: event) // Y-Position basierend auf Uhrzeit
                        )
                }
            }
            .frame(width: 100, height: totalHeight, alignment: .top)
            .clipped() // Verhindert, dass Events oben/unten rausragen
        }
    }
    
    // MARK: - Helper zur Berechnung der Position
    private func positionFor(event: Invite) -> CGFloat {
        let calendar = Calendar.current
        
        let hour = Double(calendar.component(.hour, from: event.date))
        let minute = Double(calendar.component(.minute, from: event.date))
        
        // Dezimalzeit des Events (z.B. 10:30 -> 10.5)
        let eventTime = hour + (minute / 60.0)
        
        // Differenz zum Start (z.B. 10.5 - 8.0 = 2.5 Stunden Offset)
        let offsetHours = eventTime - startHour
        
        // Pixel-Offset von oben (basierend auf der neuen, dynamischen hourHeight)
        let yOffset = CGFloat(offsetHours) * hourHeight
        
        // .position in SwiftUI platziert den MITTELPUNKT der View.
        // Wir wollen aber, dass die View oben beginnt.
        // Daher müssen wir die halbe Höhe der View dazu addieren.
        let eventHeight = CGFloat(event.duration) * hourHeight
        let halfHeight = eventHeight / 2
        
        return yOffset + halfHeight
    }
}

// MARK: - Preview
#Preview {
    // Mock Data für Preview
    // Wir brauchen ein Event, das heute um 10:00 ist
    let todayAt10 = Calendar.current.date(bySettingHour: 10, minute: 0, second: 0, of: Date())!
    
    let mockEvent = Invite(
        id: UUID(),
        titel: "Test Meeting",
        description: "Positionierung testen",
        date: todayAt10,
        duration: 2, // 2 Stunden
        attendees: []
    )
    
    CalendarDayView(day: CalendarDay(
        id: UUID(),
        dayNumber: "6",
        weekday: "DI",
        fullDateId: "2026-1-6",
        date: Date(),
        isToday: true,
        timeSlots: [],
        events: [mockEvent]
    ))
    .padding()
}
