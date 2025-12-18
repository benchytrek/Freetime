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
        ScrollView(.vertical, showsIndicators: false) {
            ZStack(alignment: .topLeading) {
                
                // 1. HINTERGRUND-RASTER (Die Linien & Uhrzeiten)
                VStack(spacing: 0) {
                    ForEach(Int(startHour)...Int(endHour), id: \.self) { hour in
                        HStack {
                            // Uhrzeit links
                            Text("\(hour):00")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                                .frame(width: 40, alignment: .trailing)
                                .offset(y: -6) // Text bündig zur Linie
                            
                            // Linie
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 1)
                        }
                        .frame(height: hourHeight, alignment: .top)
                    }
                }
                
                // 2. EVENTS (Deine Invites platzieren)
                // Wir nutzen ZStack für freie Platzierung basierend auf Zeit
                ZStack(alignment: .topLeading) {
                    ForEach(day.events) { invite in
                        EventCard(invite: invite)
                    }
                }
                .padding(.leading, 50) // Platz lassen für die Uhrzeit-Spalte links
                
                // 3. ROTE LINIE (Aktuelle Uhrzeit, nur wenn Heute)
                if day.isToday {
                    CurrentTimeLine(startHour: startHour, hourHeight: hourHeight)
                        .padding(.leading, 45)
                }
            }
            .padding(.vertical, 20)
        }
        .background(Color(.secondarySystemBackground)) // Grauer Background wie bei Apple
        .cornerRadius(20)
        // Rahmen um den Tag, damit man die Abgrenzung sieht
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(day.isToday ? Color.blue.opacity(0.5) : Color.clear, lineWidth: 2)
        )
    }
    
    // MARK: - Subviews & Helper
    
    // Das ist die Box für ein einzelnes Event
    @ViewBuilder
    func EventCard(invite: Invite) -> some View {
        let calculations = calculatePosition(for: invite.date)
        
        VStack(alignment: .leading) {
            Text(invite.titel)
                .font(.caption)
                .bold()
                .lineLimit(1)
            
            Text(invite.description)
                .font(.caption2)
                .opacity(0.8)
                .lineLimit(1)
        }
        .padding(8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 60) // Für MVP erst mal fixe Höhe (1 Stunde), später dynamisch
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.blue.opacity(0.15))
                .overlay(
                    Rectangle().fill(Color.blue).frame(width: 4),
                    alignment: .leading
                )
        )
        .offset(y: calculations.offset) // Hier passiert die Magie: Y-Position
        .padding(.trailing, 8)
    }
    
    // Berechnet wo die Box hin muss
    func calculatePosition(for date: Date) -> (offset: CGFloat, time: Double) {
        let calendar = Calendar.current
        let hour = Double(calendar.component(.hour, from: date))
        let minute = Double(calendar.component(.minute, from: date))
        
        // Uhrzeit als Kommazahl (z.B. 14:30 = 14.5)
        let timeDecimal = hour + (minute / 60.0)
        
        // Offset berechnen: (EventZeit - StartZeit) * PixelProStunde
        // max(0, ...) verhindert, dass Events vor 8 Uhr aus dem Bild fliegen
        let offset = max(0, (timeDecimal - startHour) * hourHeight)
        
        return (offset, timeDecimal)
    }
}

// Rote "Jetzt"-Linie Helper View
struct CurrentTimeLine: View {
    let startHour: Double
    let hourHeight: CGFloat
    @State private var nowOffset: CGFloat = 0
    
    var body: some View {
        HStack(spacing: 0) {
            Circle().fill(.red).frame(width: 6, height: 6)
            Rectangle().fill(.red).frame(height: 1)
        }
        .offset(y: nowOffset)
        .onAppear {
            updatePosition()
        }
    }
    
    func updatePosition() {
        let calendar = Calendar.current
        let now = Date()
        let hour = Double(calendar.component(.hour, from: now))
        let minute = Double(calendar.component(.minute, from: now))
        let timeDecimal = hour + (minute / 60.0)
        
        nowOffset = max(0, (timeDecimal - startHour) * hourHeight)
    }
}

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
