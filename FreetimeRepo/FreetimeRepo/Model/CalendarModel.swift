//
//  CalendarModel.swift
//  FreetimeRepo
//
//  Created by Ben Chytrek on 15.12.25.
//

import Foundation

struct CalendarDay: Identifiable {
    
    let id: UUID
    // Format: "YYYY-MM-DD" (z.B. "2025-01-01")
    let dateid: String
    
    let date: Date
    let dayNumber: String       // "01"
    let weekday: String         // "MO"
    let isToday: Bool           // brauch ich das?

    var timeSlots: [TimeSlot]
    

}

struct TimeSlot: Identifiable {
    
    let id = UUID()
    let time: Date
    
    
}

