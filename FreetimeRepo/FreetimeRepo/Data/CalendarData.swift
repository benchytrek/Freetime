//
//  CalendarData.swift
//  FreetimeRepo
//
//  Created by Ben Chytrek on 16.12.25.
//

import Foundation

struct CalendarData {
    
    // MARK: - Public API
    // Erstellt Kalendertage ab HEUTE
    static func generateMockDays(daysCount: Int = 30) -> [CalendarDay] {
        return generateDaysNative(count: daysCount, startDate: Date())
    }
    
    // MARK: - Generator Logik
    private static func generateDaysNative(count: Int, startDate: Date) -> [CalendarDay] {
        var generatedDays: [CalendarDay] = []
        let calendar = Calendar.current
        
        // 1. Startpunkt (bereinigt auf 00:00 Uhr)
        let startOfDay = calendar.startOfDay(for: startDate)
        
        // 2. Endpunkt
        guard let endDate = calendar.date(byAdding: .day, value: count, to: startOfDay) else { return [] }
        
        print("📅 Generiere Kalender ab \(startOfDay.formatted())")
        
        // 3. Loop
        calendar.enumerateDates(
            startingAfter: startOfDay,
            matching: DateComponents(hour: 0, minute: 0, second: 0),
            matchingPolicy: .nextTime
        ) { (date, exactMatch, stop) in
            
            if let date = date {
                if date > endDate {
                    stop = true
                } else {
                    // Check ob das Datum "Heute" ist
                    let isToday = calendar.isDate(date, inSameDayAs: startDate)
                    let dayModel = createDayModel(from: date, isToday: isToday)
                    generatedDays.append(dayModel)
                }
            }
        }
        
        // Den Start-Tag manuell hinzufügen
        let firstDayModel = createDayModel(from: startOfDay, isToday: true)
        generatedDays.insert(firstDayModel, at: 0)
        
        return generatedDays
    }
    
    private static func createDayModel(from date: Date, isToday: Bool) -> CalendarDay {
        let dayNumber = date.formatted(.dateTime.day(.twoDigits))
        let weekday = date.formatted(.dateTime.weekday(.abbreviated)).uppercased()
        let dateId = date.formatted(.iso8601.year().month().day().dateSeparator(.dash))
        
        return CalendarDay(
            id: UUID(),
            dayNumber: dayNumber,
            weekday: weekday,
            fullDateId: dateId,
            date: date,
            isToday: isToday,
            timeSlots: [], // Leer, Events kommen später rein
            events: []     // Leer, wird im ViewModel gefüllt
        )
    }
}
