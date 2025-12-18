//
//  CalendarDateRow.swift
//  FreetimeRepo
//
//  Created by Ben Chytrek on 15.12.25.
//

import SwiftUI

struct CalendarDateRow: View {
    // Wir bekommen die 3 Tage, die gerade sichtbar sind
    let days: [CalendarDay]
    
    var body: some View {
        HStack(spacing: 0) {
            // Platzhalter für TimeColumn (damit es bündig ist)
            Color.clear
                .frame(width: 50)
            
            // Die 3 Spalten Headers
            HStack(spacing: 0) {
                ForEach(days) { day in
                    VStack(spacing: 4) {
                        Text(day.weekday)
                            .font(.caption2.bold())
                            .foregroundStyle(.secondary)
                        
                        ZStack {
                            if day.isToday {
                                Circle()
                                    .fill(Color.accentColor)
                                    .frame(width: 32, height: 32)
                            }
                            Text(day.dayNumber)
                                .font(.headline)
                                .foregroundStyle(day.isToday ? .white : .primary)
                        }
                    }
                    .frame(maxWidth: .infinity) // Nimmt 1/3 Platz ein
                    .padding(.vertical, 10)
                }
            }
        }
        .background(Color(.systemBackground))
        .overlay(Divider(), alignment: .bottom)
    }
}

//preview hinzufügen ..... gemini
//#Preview {CalendarDateRow(days: Array(viewModel.days[1,2,3]))}
