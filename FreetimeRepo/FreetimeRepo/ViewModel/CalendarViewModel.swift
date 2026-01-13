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
    
    // NEU: Wir merken uns die ID von "Heute", um direkt dort hinzuspringen
    var todayId: UUID?
    
    init() {
        loadData()
    }
    
    func loadData() {
        // 1. STATISCHE DATEN LADEN
        var tempDays = CalendarData.year2026
        
        // 2. EVENTS LADEN
        let allInvites = InviteData.allInvites
        
        // 3. MAPPING
        for i in 0..<tempDays.count {
            let dayDate = tempDays[i].date
            
            let eventsForThisDay = allInvites.filter { invite in
                Calendar.current.isDate(invite.date, inSameDayAs: dayDate)
            }
            
            if !eventsForThisDay.isEmpty {
                tempDays[i].events = eventsForThisDay.sorted(by: { $0.date < $1.date })
            }
        }
        
        // 4. "HEUTE" FINDEN
        // Wir suchen den Tag, der tatsächlich "Heute" ist.
        // Falls wir heute (2025) sind, der Kalender aber 2026 ist, wird 'today' nil sein.
        // In dem Fall nehmen wir einfach den allerersten Tag (1.1.2026).
        if let today = tempDays.first(where: { $0.isToday }) {
            self.todayId = today.id
        } else {
            self.todayId = tempDays.first?.id
        }
        
        // 5. Update UI
        self.days = tempDays
    }
}
