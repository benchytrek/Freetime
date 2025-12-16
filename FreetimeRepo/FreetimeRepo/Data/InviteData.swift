//
//  InviteData.swift
//  FreetimeRepo
//
//  Created by Ben Chytrek on 10.12.25.
//

import Foundation

struct InviteData {
    
    // MARK: - Helper (Apple Clean Code)
    static func makeDate(year: Int, month: Int, day: Int, hour: Int, minute: Int) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        return Calendar.current.date(from: components) ?? Date()
    }
    
    // MARK: - Einzelne Invites definieren
    // Wir definieren sie hier einzeln, damit wir sie später leicht wiederfinden
    
    static let schrankEskalation = Invite(
        id: UUID(),
        titel: "Schrank Eskalation",
        description: "Lass mal unten auflegen",
        // Z.B. Heute Abend (angenommen 20.12.25)
        date: makeDate(year: 2025, month: 12, day: 20, hour: 20, minute: 00),
        attendees: [
            InviteAttendee(user: UserData.ben, status: .yes),
            InviteAttendee(user: UserData.philip, status: .pending),
            InviteAttendee(user: UserData.tim, status: .maybe),
            InviteAttendee(user: UserData.ruben, status: .no)
        ]
    )
    
    static let bouldern = Invite(
        id: UUID(),
        titel: "Bouldern",
        description: "und Sauna, Wichtig",
        // Z.B. Morgen Vormittag (21.12.25)
        date: makeDate(year: 2025, month: 12, day: 21, hour: 10, minute: 30),
        attendees: [
            InviteAttendee(user: UserData.ben, status: .yes),
            InviteAttendee(user: UserData.lena, status: .yes),
            InviteAttendee(user: UserData.philip, status: .no),
            InviteAttendee(user: UserData.ramonski, status: .no),
            InviteAttendee(user: UserData.sophie, status: .maybe)
        ]
    )
    
    static let urlaub = Invite(
        id: UUID(),
        titel: "Urlaub",
        description: "",
        // Z.B. Übermorgen (22.12.25)
        date: makeDate(year: 2025, month: 12, day: 22, hour: 09, minute: 00),
        attendees: [
            InviteAttendee(user: UserData.ben, status: .yes),
            InviteAttendee(user: UserData.lena, status: .maybe),
            InviteAttendee(user: UserData.philip, status: .yes)
        ]
    )
    
    static let freetimeDev = Invite(
        id: UUID(),
        titel: "Freetime Dev",
        description: "diggi weiter programmieren",
        // Z.B. Heute Mittag (20.12.25)
        date: makeDate(year: 2025, month: 12, day: 20, hour: 14, minute: 00),
        attendees: [
            InviteAttendee(user: UserData.ben, status: .yes)
        ]
    )

    // MARK: - Die Liste für die App
    // Hier fügen wir einfach die oben definierten Teile zusammen
    static let allInvites: [Invite] = [
        schrankEskalation,
        bouldern,
        urlaub,
        freetimeDev
    ]
}
