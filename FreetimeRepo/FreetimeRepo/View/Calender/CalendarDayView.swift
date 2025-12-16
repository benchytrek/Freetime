//
//  CalendarDayView.swift
//  FreetimeRepo
//
//  Created by Ben Chytrek on 15.12.25.
//

import SwiftUI

struct CalendarDayView: View {
    let day: CalendarDay
    
    var body: some View {
        VStack(spacing: 0) {
            
            // 1. HEADER
            VStack(spacing: 4) {
                Text(day.weekday)
                    .font(.caption2.bold())
                    .foregroundStyle(.secondary)
                
                ZStack {
                    if day.isToday {
                        Circle()
                            .fill(Color.accentColor)
                            .frame(width: 32, height: 32)
                            .shadow(color: Color.accentColor.opacity(0.3), radius: 4, y: 2)
                    }
                    Text(day.dayNumber)
                        .font(.title3.bold())
                        .foregroundStyle(day.isToday ? .white : .primary)
                }
            }
            .padding(.top, 20)
            .padding(.bottom, 10)
            
            Divider()
            
            // 2. EVENT LISTE (Der "Connect")
            // Hier zeigen wir die Events an, die das ViewModel gefunden hat
            ScrollView {
                VStack(spacing: 12) {
                    if day.events.isEmpty {
                        // Leerer Zustand (Free Time?)
                        ContentUnavailableView("such dir nen hobby", systemImage: "calendar.badge.plus", description: Text("Hell yeah."))
                            .scaleEffect(0.8)
                            .opacity(0.5)
                            .padding(.top, 40)
                    } else {
                        ForEach(day.events) { invite in
                            // Kleine Karte für das Event im Kalender
                            HStack {
                                Rectangle()
                                    .fill(Color.green)
                                    .frame(width: 4)
                                    .cornerRadius(2)
                                
                                VStack(alignment: .leading) {
                                    Text(invite.titel)
                                        .font(.subheadline.bold())
                                    Text(invite.date.formatted(date: .omitted, time: .shortened))
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                            }
                            .padding(8)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }
                    }
                }
                .padding()
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color(.secondarySystemBackground))
                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
        .frame(height: 500)
    }
}

#Preview {
    // 1. Tag mit Event (Heute)
    let today = Date()
    let dayWithEvent = CalendarDay(
        id: UUID(),
        dayNumber: "16",
        weekday: "DI",
        fullDateId: "2025-12-16",
        date: today,
        isToday: true,
        timeSlots: [],
        events: [InviteData.schrankEskalation]
    )
    
    // 2. Tag ohne Event (Morgen)
    // Wir nutzen Calendar, um sauber +1 Tag zu rechnen
    let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
    let dayEmpty = CalendarDay(
        id: UUID(),
        dayNumber: "17",
        weekday: "MI",
        fullDateId: "2025-12-17",
        date: tomorrow,
        isToday: false,
        timeSlots: [],
        events: [] // Leer
    )
    
    // Preview Layout: Zwei Karten nebeneinander scrollbar simulieren
    ScrollView(.horizontal) {
        HStack(spacing: 10) {
            CalendarDayView(day: dayWithEvent)
                .frame(width: 100)
            
            CalendarDayView(day: dayEmpty)
                .frame(width: 100)
            CalendarDayView(day: dayEmpty)
                .frame(width: 100)
        }
        .padding()
    }
    .background(Color(.systemBackground))
}
