//
//  CalendarModel.swift
//  FreetimeRepo
//
//  Created by Ben Chytrek on 16.12.25.
//

import Foundation

// MARK: - Calendar Day Model
// Repräsentiert einen einzelnen Tag in der horizontalen Scroll-Ansicht
struct CalendarDay: Identifiable, Equatable {
    let id: UUID
    
    // UI-Formatierte Strings (Damit die View nicht rechnen muss)
    let dayNumber: String       // z.B. "16"
    let weekday: String         // z.B. "MO"
    let fullDateId: String      // z.B. "2025-12-16" (gut für DB-Keys)
    
    // Logik-Properties
    let date: Date              // Das echte Date-Objekt (Start of Day)
    let isToday: Bool
    
    // Inhalte
    var timeSlots: [TimeSlot]
    
    // Equatable Implementierung für Performance (SwiftUI rendered nur neu, wenn sich was ändert)
    static func == (lhs: CalendarDay, rhs: CalendarDay) -> Bool {
        return lhs.id == rhs.id && lhs.isToday == rhs.isToday && lhs.timeSlots == rhs.timeSlots
    }
}

// MARK: - Time Slot Model
// Repräsentiert eine Stunde an einem Tag (z.B. 14:00 - 15:00 Uhr)
struct TimeSlot: Identifiable, Equatable {
    let id: UUID
    let time: Date              // Die exakte Startzeit (z.B. 16.12.25 14:00:00)
    
    // Später können wir hier noch Events reinpacken:
    // var event: Invite?
}
