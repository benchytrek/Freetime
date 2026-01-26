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
    let id: String
    
    // UI-Formatierte Strings
    let dayNumber: String       // z.B. "16"
    let weekday: String         // z.B. "MO"
    let fullDateId: String      // z.B. "2025-12-16"
    
    // Logik-Properties
    let date: Date              // Das echte Date-Objekt (Start of Day)
    let isToday: Bool
    
    // Inhalte
    var timeSlots: [TimeSlot]
    
    // NEU: Hier landen die gematchten Invites
    // Das behebt den Fehler "Value of type 'CalendarDay' has no member 'events'"
    var events: [Invite] = []
    
    // Equatable Implementierung
    static func == (lhs: CalendarDay, rhs: CalendarDay) -> Bool {
        // Wir vergleichen jetzt auch die Events, damit das UI sich aktualisiert
        return lhs.id == rhs.id &&
               lhs.isToday == rhs.isToday &&
               lhs.timeSlots == rhs.timeSlots &&
               lhs.events.count == rhs.events.count
    }
}

// MARK: - Time Slot Model
struct TimeSlot: Identifiable, Equatable {
    let id: UUID
    let time: Date
}
