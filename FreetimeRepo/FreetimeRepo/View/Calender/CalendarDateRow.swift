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
            VStack(spacing: 4) {
                Text(day.weekday)
                    .font(.caption2.bold())
                    .foregroundStyle(.secondary)
                
                ZStack {
                    if day.isToday {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 32, height: 32)
                    }
                    Text(day.dayNumber)
                        .font(.headline)
                        .foregroundStyle(day.isToday ? .white : .primary)
                }
            }
            .frame(height: 50) // Fixe Höhe für sauberes Layout
        }
    }


