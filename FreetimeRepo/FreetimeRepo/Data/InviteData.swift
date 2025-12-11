//
//  InviteData.swift
//  FreetimeRepo
//
//  Created by Ben Chytrek on 10.12.25.
//

import Foundation

struct InviteData {
    
    static let allInvites: [Invite] = [
        // 1. Pizza (Heute Mittag)
        Invite(
            id: UUID(),
            titel: "Pizza Mittag",
            description: "Lust auf Pizzeria Napoli?",
            date: Date().addingTimeInterval(3600 * 2), // In 2 Std
            attendees: [
                InviteAttendee(user: UserData.ben, status: .yes),
                InviteAttendee(user: UserData.anna, status: .pending),
                InviteAttendee(user: UserData.tom, status: .maybe)
            ]
        ),
        
        // 2. Gym (Morgen früh)
        Invite(
            id: UUID(),
            titel: "Gym Session",
            description: "Leg Day! Wer ist dabei?",
            date: Date().addingTimeInterval(86400), // +1 Tag
            attendees: [
                InviteAttendee(user: UserData.ben, status: .yes),
                InviteAttendee(user: UserData.max, status: .yes)
            ]
        ),
        
        // 3. Große Party (Viele Teilnehmer -> testet die "+X" Bubble)
        Invite(
            id: UUID(),
            titel: "Hausparty",
            description: "Bei Chris zuhause",
            date: Date().addingTimeInterval(86400 * 2), // +2 Tage
            attendees: [
                InviteAttendee(user: UserData.chris, status: .yes),
                InviteAttendee(user: UserData.lisa, status: .yes),
                InviteAttendee(user: UserData.sarah, status: .maybe),
                InviteAttendee(user: UserData.tom, status: .no),
                InviteAttendee(user: UserData.julia, status: .yes),
                InviteAttendee(user: UserData.david, status: .pending),
                InviteAttendee(user: UserData.laura, status: .yes)
            ]
        ),
        
        // 4. Lernen (Nur 1 Person)
        Invite(
            id: UUID(),
            titel: "Lernen Bib",
            description: "Mathe Klausurvorbereitung",
            date: Date().addingTimeInterval(3600 * 5),
            attendees: [
                InviteAttendee(user: UserData.lisa, status: .yes)
            ]
        ),
        
        // 5. Kino
        Invite(
            id: UUID(),
            titel: "Kino Abend",
            description: "Dune Part 2",
            date: Date().addingTimeInterval(3600 * 8), // Abends
            attendees: [
                InviteAttendee(user: UserData.ben, status: .yes),
                InviteAttendee(user: UserData.anna, status: .yes),
                InviteAttendee(user: UserData.laura, status: .pending),
                InviteAttendee(user: UserData.max, status: .no)
            ]
        ),
        
        // 6. Joggen
        Invite(
            id: UUID(),
            titel: "Runde Laufen",
            description: "Im Park, lockeres Tempo",
            date: Date().addingTimeInterval(86400 * 1.5),
            attendees: [
                InviteAttendee(user: UserData.david, status: .yes),
                InviteAttendee(user: UserData.tom, status: .yes)
            ]
        ),
        
        // 7. Brunch
        Invite(
            id: UUID(),
            titel: "Sonntags Brunch",
            description: "Café Extrablatt",
            date: Date().addingTimeInterval(86400 * 3),
            attendees: [
                InviteAttendee(user: UserData.julia, status: .pending),
                InviteAttendee(user: UserData.sarah, status: .yes),
                InviteAttendee(user: UserData.lisa, status: .maybe)
            ]
        ),
        
        // 8. Gaming
        Invite(
            id: UUID(),
            titel: "Zocken",
            description: "Discord & LoL",
            date: Date().addingTimeInterval(3600 * 20),
            attendees: [
                InviteAttendee(user: UserData.max, status: .yes),
                InviteAttendee(user: UserData.ben, status: .yes),
                InviteAttendee(user: UserData.chris, status: .maybe)
            ]
        ),
        
        // 9. Meeting
        Invite(
            id: UUID(),
            titel: "Projektbesprechung",
            description: "Freetime App Roadmap",
            date: Date().addingTimeInterval(3600 * 24),
            attendees: [
                InviteAttendee(user: UserData.ben, status: .yes),
                InviteAttendee(user: UserData.anna, status: .yes),
                InviteAttendee(user: UserData.tom, status: .yes),
                InviteAttendee(user: UserData.lisa, status: .pending)
            ]
        ),
        
        // 10. Einkaufen
        Invite(
            id: UUID(),
            titel: "Geschenk kaufen",
            description: "Für Sarahs Geburtstag",
            date: Date().addingTimeInterval(3600 * 4),
            attendees: [
                InviteAttendee(user: UserData.julia, status: .yes),
                InviteAttendee(user: UserData.laura, status: .yes)
            ]
        )
    ]
}
