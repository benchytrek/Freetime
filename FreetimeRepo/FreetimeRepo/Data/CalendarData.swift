//
//  CalendarData.swift
//  FreetimeRepo
//
//  Created by Ben Chytrek on 16.12.25.
//

import Foundation

struct CalendarData {
    
    // MARK: - Public API (Statische Liste)
    // Diese Liste wird genau EINMAL berechnet (lazy) und dann im Speicher gehalten.
    // Das ist performanter als jedes Mal neu zu generieren.
    static let year2026: [CalendarDay] = generateFullYear2026()
    
    // MARK: - Generator Logik (Intern)
    private static func generateFullYear2026() -> [CalendarDay] {
        let calendar = Calendar.current
        
        // 1. Startdatum festlegen: 01.01.2026
        var startComponents = DateComponents()
        startComponents.year = 2026
        startComponents.month = 1
        startComponents.day = 1
        
        guard let startDate = calendar.date(from: startComponents) else { return [] }
        
        // 2. Anzahl der Tage im Jahr 2026 ermitteln (sicherer als fest 365)
        guard let range = calendar.range(of: .day, in: .year, for: startDate) else { return [] }
        let dayCount = range.count // 365 oder 366
        
        print("🚀 Initialisiere statischen Kalender 2026 (\(dayCount) Tage)...")
        
        // 3. Generierung starten
        return generateDaysNative(count: dayCount, startDate: startDate)
    }
    
    private static func generateDaysNative(count: Int, startDate: Date) -> [CalendarDay] {
        var generatedDays: [CalendarDay] = []
        let calendar = Calendar.current
        
        // Start sicherstellen (00:00 Uhr)
        let startOfDay = calendar.startOfDay(for: startDate)
        
        // End-Datum berechnen
        guard let endDate = calendar.date(byAdding: .day, value: count, to: startOfDay) else { return [] }
        
        // Loop durch die Tage
        calendar.enumerateDates(
            startingAfter: startOfDay,
            matching: DateComponents(hour: 0, minute: 0, second: 0),
            matchingPolicy: .nextTime
        ) { (date, exactMatch, stop) in
            
            if let date = date {
                if date > endDate {
                    stop = true
                } else {
                    let dayModel = createDayModel(from: date)
                    generatedDays.append(dayModel)
                }
            }
        }
        
        // Den Start-Tag (01.01.) manuell hinzufügen, da enumerateDates "nach" dem Start beginnt
        let firstDayModel = createDayModel(from: startOfDay)
        generatedDays.insert(firstDayModel, at: 0)
        
        return generatedDays
    }
    
    private static func createDayModel(from date: Date) -> CalendarDay {
        let dayNumber = date.formatted(.dateTime.day(.twoDigits))
        let weekday = date.formatted(.dateTime.weekday(.abbreviated)).uppercased()
        let dateId = date.formatted(.iso8601.year().month().day().dateSeparator(.dash))
        
        // Wir prüfen dynamisch gegen das aktuelle Datum des Geräts
        let isToday = Calendar.current.isDateInToday(date)
        
        return CalendarDay(
            id: UUID(),
            dayNumber: dayNumber,
            weekday: weekday,
            fullDateId: dateId,
            date: date,
            isToday: isToday,
            timeSlots: [],
            events: []
        )
    }
}
