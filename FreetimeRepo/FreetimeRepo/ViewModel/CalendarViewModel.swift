//
//  CalendarViewModel.swift
//  FreetimeRepo
//
//  Created by Ben Chytrek on 15.12.25.
//

import Foundation
import SwiftUI
import Observation

@Observable
class CalendarViewModel {
    
    var days: [CalendarDay] = []
    
    init() {
        loadData()
    }
    
    func loadData() {
        // 1. Kalender generieren (Startet automatisch bei HEUTE)
        // Wir generieren z.B. 30 Tage ab heute.
        // Wenn heute der 16.12. ist, generieren wir [16.12, 17.12, ..., 15.01]
        var tempDays = CalendarData.generateMockDays(daysCount: 30)
        
        // 2. INVITES LADEN
        // Das sind deine festen Events aus InviteData (z.B. 20.12.2025)
        let allInvites = InviteData.allInvites
        
        // 3. CONNECTEN (Mapping)
        // Wir gehen jeden generierten Tag durch
        for i in 0..<tempDays.count {
            let dayDate = tempDays[i].date
            
            // Wir suchen Invites, die genau an diesem Tag stattfinden
            // Apple Calendar hilft uns beim Vergleich (ignoriert Uhrzeit)
            let eventsForThisDay = allInvites.filter { invite in
                Calendar.current.isDate(invite.date, inSameDayAs: dayDate)
            }
            
            // Wenn Events gefunden wurden, weisen wir sie dem Tag zu
            if !eventsForThisDay.isEmpty {
                tempDays[i].events = eventsForThisDay.sorted(by: { $0.date < $1.date })
                print("✅ Event gefunden für \(dayDate.formatted()): \(eventsForThisDay.map(\.titel))")
            }
        }
        
        // 4. Update UI
        self.days = tempDays
    }
}
