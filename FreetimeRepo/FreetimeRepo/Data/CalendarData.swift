//
//  CalendarData.swift
//  FreetimeRepo
//
//  Created by Ben Chytrek on 16.12.25.
//

import Foundation

// Diese Struct ist unsere "Source of Truth" für Kalender-Daten
struct CalendarData {
    
    // MARK: - Public API
    // Rufe das hier in deinem ViewModel auf: CalendarData.generateMockDays()
    static func generateMockDays(daysCount: Int = 30) -> [CalendarDay] {
        return generateDaysNative(count: daysCount)
    }
    
    // MARK: - Generator Logik (The Apple Way)
    // Basiert auf 'enumerateDates', um Zeitzonen- und Schaltjahr-Probleme zu vermeiden.
    private static func generateDaysNative(count: Int) -> [CalendarDay] {
        var generatedDays: [CalendarDay] = []
        let calendar = Calendar.current
        
        // 1. Startpunkt: Heute um 00:00:00 Uhr (Start of Day)
        let today = calendar.startOfDay(for: Date())
        
        // 2. Endpunkt: Heute + X Tage
        guard let endDate = calendar.date(byAdding: .day, value: count, to: today) else { return [] }
        
        print("📅 Generiere Kalender vom \(today.formatted()) bis \(endDate.formatted())")
        
        // 3. Apple Magic Loop: Gehe jeden Tag durch
        // matching: .hour: 0 sucht immer nach Mitternacht -> Findet zuverlässig jeden Tag
        calendar.enumerateDates(
            startingAfter: today, // Startet morgen (enumerateDates ist exklusiv)
            matching: DateComponents(hour: 0, minute: 0, second: 0),
            matchingPolicy: .nextTime
        ) { (date, exactMatch, stop) in
            
            // Dieser Block wird für jeden gefundenen Tag ausgeführt
            if let date = date {
                if date > endDate {
                    stop = true // Stop, wenn wir das Ziel erreicht haben
                } else {
                    // Tag erstellen
                    let dayModel = createDayModel(from: date, isToday: false)
                    generatedDays.append(dayModel)
                }
            }
        }
        
        // 4. "Heute" manuell hinzufügen (da enumerateDates bei 'startingAfter' beginnt)
        let todayModel = createDayModel(from: today, isToday: true)
        generatedDays.insert(todayModel, at: 0)
        
        return generatedDays
    }
    
    // MARK: - Helper: Einzelnen Tag bauen
    private static func createDayModel(from date: Date, isToday: Bool) -> CalendarDay {
        // Formatter Strategie (ISO8601 & Locale Aware)
        let dayNumber = date.formatted(.dateTime.day(.twoDigits)) // "16"
        let weekday = date.formatted(.dateTime.weekday(.abbreviated)).uppercased() // "DI"
        let dateId = date.formatted(.iso8601.year().month().day().dateSeparator(.dash)) // "2025-12-16"
        
        // Slots generieren (8 bis 23 Uhr)
        let slots = generateTimeSlots(for: date)
        
        return CalendarDay(
            id: UUID(),
            dayNumber: dayNumber,
            weekday: weekday,
            fullDateId: dateId,
            date: date,
            isToday: isToday,
            timeSlots: slots
        )
    }
    
    // MARK: - Helper: Slots generieren
    private static func generateTimeSlots(for date: Date) -> [TimeSlot] {
        var slots: [TimeSlot] = []
        let calendar = Calendar.current
        
        // Wir nehmen an, der Tag geht von 08:00 bis 23:00 Uhr
        let startHour = 8
        let endHour = 23
        
        for hour in startHour...endHour {
            // Erstelle ein Date-Objekt für genau diese Stunde (z.B. 16.12.25 14:00:00)
            if let slotDate = calendar.date(bySettingHour: hour, minute: 0, second: 0, of: date) {
                let slot = TimeSlot(
                    id: UUID(),
                    time: slotDate
                )
                slots.append(slot)
            }
        }
        return slots
    }
}
