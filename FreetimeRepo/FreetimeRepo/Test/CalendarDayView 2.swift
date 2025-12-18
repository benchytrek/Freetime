//
//  CalendarDayView.swift
//  FreetimeRepo
//
//  Created by Ben Chytrek on 15.12.25.
//

#if false
func testBrokenFeature() {
    // Dieser Code wird vom Compiler komplett ignoriert
    // bis du "#if false" entfernst.


//import SwiftUI

struct CalendarDayViewTest: View {
    let day: CalendarDay
    
    // Layout Konfiguration (Muss identisch zur TimeColumn sein)
    let startHour: Double = 8
    let endHour: Double = 22
    let hourHeight: CGFloat = 60
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            
            // 1. GRID LINES (Hintergrund)
            // Zeichnet horizontale Linien für jede Stunde
            VStack(spacing: 0) {
                ForEach(Int(startHour)...Int(endHour), id: \.self) { _ in
                    Divider()
                        .frame(height: hourHeight, alignment: .top)
                }
            }
            .opacity(0.3)
            
            // 2. EVENTS (Positioniert)
            ForEach(day.events) { invite in
                eventCard(for: invite)
            }
            
            // 3. AKTUELLE ZEIT LINIE (Optional: Roter Strich für "Jetzt")
            if day.isToday {
                DayCurrentTimeLine(startHour: startHour, hourHeight: hourHeight)
            }
        }
        // Gesamthöhe berechnen: (22 - 8 + 1) * 60
        .frame(height: (CGFloat(endHour - startHour) + 1) * hourHeight)
        .background(Color(.secondarySystemBackground).opacity(0.3))
        .clipped() // Damit Events nicht rausstehen
    }
    
    // MARK: - Event Box Builder
    @ViewBuilder
    func eventCard(for invite: Invite) -> some View {
        // Berechne Position
        let calendar = Calendar.current
        let hour = Double(calendar.component(.hour, from: invite.date))
        let minute = Double(calendar.component(.minute, from: invite.date))
        
        // Zeit als Dezimalzahl (z.B. 14:30 -> 14.5)
        let timeDecimal = hour + (minute / 60.0)
        
        // Offset: (Zeit - Startzeit) * PixelProStunde
        let offset = (timeDecimal - startHour) * hourHeight
        
        // Dauer (für MVP nehmen wir 1h oder 2h an, später aus Invite Model)
        // Sagen wir fix 1.5 Stunden Höhe für den Look
        let durationHeight = 1.5 * hourHeight
        
        // UI der Box
        VStack(alignment: .leading, spacing: 2) {
            Text(invite.titel)
                .font(.caption.bold())
                .lineLimit(1)
            Text(invite.date.formatted(date: .omitted, time: .shortened))
                .font(.caption2)
                .opacity(0.8)
        }
        .padding(6)
        .frame(maxWidth: .infinity, alignment: .leading) // Volle Spaltenbreite
        .frame(height: durationHeight)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.blue.opacity(0.2))
                .overlay(
                    Rectangle().fill(Color.blue).frame(width: 3),
                    alignment: .leading
                )
        )
        .padding(.horizontal, 2)
        .offset(y: max(0, offset)) // Positionierung
    }
}

// Helper für rote Linie
struct DayCurrentTimeLine: View {
    let startHour: Double
    let hourHeight: CGFloat
    @State private var currentDate = Date()
    
    var body: some View {
        let calendar = Calendar.current
        let hour = Double(calendar.component(.hour, from: currentDate))
        let minute = Double(calendar.component(.minute, from: currentDate))
        let timeDecimal = hour + (minute / 60.0)
        let offset = (timeDecimal - startHour) * hourHeight
        
        if offset >= 0 {
            Rectangle()
                .fill(Color.red)
                .frame(height: 1)
                .overlay(
                    Circle().fill(Color.red).frame(width: 6, height: 6),
                    alignment: .leading
                )
                .offset(y: offset)
        }
    }
}

#Preview {
    CalendarDayViewTest(day: CalendarDay(
        id: UUID(),
        dayNumber: "16",
        weekday: "DI",
        fullDateId: "2025-12-16",
        date: Date(),
        isToday: true,
        timeSlots: [],
        events: [InviteData.schrankEskalation]
    ))
}
}
#endif
