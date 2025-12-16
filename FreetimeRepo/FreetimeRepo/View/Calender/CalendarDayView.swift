//
//  CalenderDayView.swift
//  FreetimeRepo
//
//  Created by Ben Chytrek on 15.12.25.
//

import SwiftUI

struct CalendarDayView: View {
    // MARK: - Properties
    let date: Date
    let isToday: Bool
    
    // Konfiguration für die Timeline (8 bis 23 Uhr)
    private let startHour = 8
    private let endHour = 23
    
    var body: some View {
        VStack(spacing: 0) {
            
            // 1. HEADER: Wochentag & Datum
            VStack(spacing: 4) {
                Text(date.formatted(.dateTime.weekday(.abbreviated)).uppercased())
                    .font(.caption2.bold())
                    .foregroundStyle(.secondary)
                
                ZStack {
                    if isToday {
                        Circle()
                            .fill(Color.accentColor)
                            .frame(width: 32, height: 32)
                            // Leichter Glow Effekt für "Heute"
                            .shadow(color: Color.accentColor.opacity(0.3), radius: 4, x: 0, y: 2)
                    }
                    Text(date.formatted(.dateTime.day()))
                        .font(.title3.bold())
                        .foregroundStyle(isToday ? .white : .primary)
                }
            }
            .padding(.top, 20)
            
            Divider()
                .padding(.vertical, 10)
            
            // 2. TIMELINE BODY
            // Hier nutzen wir ein ZStack, damit wir später die Events OBEN DRAUF legen können
            
            .frame(maxHeight: .infinity)
            .padding(.bottom, 20)
        }
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color(.secondarySystemBackground))
                // iOS-Style Schatten für Tiefe
                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
        // Fixe Höhe für den Balken (oder später GeometryReader für Fullscreen)
        .frame(height: 500)
    }
}

#Preview {
    HStack(spacing: 20) {
        // Preview zeigt zwei Zustände: Normal und Heute
        CalendarDayView(date: Date(), isToday: true)
        CalendarDayView(date: Date().addingTimeInterval(86400), isToday: false)
    }
    .padding()
}
