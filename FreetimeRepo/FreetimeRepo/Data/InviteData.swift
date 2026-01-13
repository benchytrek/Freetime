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
    
    static let arbeiten1 = Invite(
        id: UUID(),
        titel: "ATIW",
        description: "schule",
        date: makeDate(year: 2026, month: 1, day: 5, hour: 15, minute: 00),
        duration: 8,
        attendees: [
            InviteAttendee(user: UserData.ben, status: .yes),
        ]
    )
    
    static let arbeiten2 = Invite(
        id: UUID(),
        titel: "ATIW",
        description: "schule",
        date: makeDate(year: 2026, month: 1, day: 14, hour: 8, minute: 00),
        duration: 8,
        attendees: [
            InviteAttendee(user: UserData.ben, status: .yes),
        ]
    )
    
    
    static let schrankEskalation = Invite(
        id: UUID(),
        titel: "Schrank Eskalation",
        description: "Lass mal unten auflegen",
        // Z.B. Heute Abend (angenommen 20.12.25)
        date: makeDate(year: 2026, month: 1, day: 14, hour: 20, minute: 00),
        duration: 2,
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
        date: makeDate(year: 2026, month: 1, day: 12, hour: 18, minute: 30),
        duration: 3,
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
        date: makeDate(year: 2026, month: 1, day: 10, hour: 09, minute: 00),
        duration: 4,
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
        date: makeDate(year: 2026, month: 1, day: 11, hour: 14, minute: 00),
        duration: 1,
        attendees: [
            InviteAttendee(user: UserData.ben, status: .yes)
        ]
    )
    // MARK: - Triathlon & Training Invites
        
        static let morningSwim = Invite(
            id: UUID(),
            titel: "Frühschwimmen",
            description: "Technik & Ausdauer, Bahn 1 reserviert",
            date: makeDate(year: 2026, month: 1, day: 15, hour: 06, minute: 30),
            duration: 1,
            attendees: [
                InviteAttendee(user: UserData.ben, status: .yes),
                InviteAttendee(user: UserData.tim, status: .maybe),
                InviteAttendee(user: UserData.anne, status: .yes)
            ]
        )
        
        static let longRide = Invite(
            id: UUID(),
            titel: "Lange Ausfahrt",
            description: "GA1 Runde, ca. 80km, Kaffeepause eingeplant",
            date: makeDate(year: 2026, month: 1, day: 17, hour: 10, minute: 00),
            duration: 3,
            attendees: [
                InviteAttendee(user: UserData.ben, status: .yes),
                InviteAttendee(user: UserData.philip, status: .yes),
                InviteAttendee(user: UserData.ramonski, status: .no)
            ]
        )
        
        static let trackIntervals = Invite(
            id: UUID(),
            titel: "Track Night",
            description: "400m Intervalle ballern, danach Dehnen",
            date: makeDate(year: 2026, month: 1, day: 20, hour: 18, minute: 00),
            duration: 2,
            attendees: [
                InviteAttendee(user: UserData.ben, status: .yes),
                InviteAttendee(user: UserData.tom, status: .yes)
            ]
        )
        
        static let brickSession = Invite(
            id: UUID(),
            titel: "Koppeltraining",
            description: "40km Rad + 5km Lauf (Wettkampf-Pace)",
            date: makeDate(year: 2026, month: 1, day: 24, hour: 09, minute: 00),
            duration: 2,
            attendees: [
                InviteAttendee(user: UserData.ben, status: .yes),
                InviteAttendee(user: UserData.lena, status: .maybe)
            ]
        )
        
        static let zwiftRace = Invite(
            id: UUID(),
            titel: "Zwift Race",
            description: "Watopia Flat Route, Discord ist an",
            date: makeDate(year: 2026, month: 1, day: 21, hour: 19, minute: 00),
            duration: 1,
            attendees: [
                InviteAttendee(user: UserData.ben, status: .yes),
                InviteAttendee(user: UserData.ruben, status: .pending)
            ]
        )
        
        static let gymStrength = Invite(
            id: UUID(),
            titel: "Athletik & Stabi",
            description: "Rumpfstabi ist wichtig für die Aero-Position!",
            date: makeDate(year: 2026, month: 1, day: 16, hour: 17, minute: 30),
            duration: 1,
            attendees: [
                InviteAttendee(user: UserData.ben, status: .yes),
                InviteAttendee(user: UserData.sophie, status: .yes)
            ]
        )
        
        static let recoveryYoga = Invite(
            id: UUID(),
            titel: "Recovery Yoga",
            description: "Mobility Flow für Hüfte und Rücken",
            date: makeDate(year: 2026, month: 1, day: 18, hour: 10, minute: 00),
            duration: 1,
            attendees: [
                InviteAttendee(user: UserData.ben, status: .maybe),
                InviteAttendee(user: UserData.lena, status: .yes),
                InviteAttendee(user: UserData.mama, status: .yes)
            ]
        )
        
        static let longRun = Invite(
            id: UUID(),
            titel: "Long Run",
            description: "20km locker, Podcast an und los",
            date: makeDate(year: 2026, month: 1, day: 25, hour: 08, minute: 00),
            duration: 2,
            attendees: [
                InviteAttendee(user: UserData.ben, status: .yes)
            ]
        )
        
        static let bikeFitting = Invite(
            id: UUID(),
            titel: "Bike Fitting",
            description: "Sattelhöhe und Cleats einstellen bei Canyon",
            date: makeDate(year: 2026, month: 1, day: 28, hour: 14, minute: 00),
            duration: 2,
            attendees: [
                InviteAttendee(user: UserData.ben, status: .yes),
                InviteAttendee(user: UserData.philip, status: .maybe)
            ]
        )
        
        static let triathlonMeetup = Invite(
            id: UUID(),
            titel: "Tri-Team Pizza",
            description: "Saisonplanung und Carb-Loading",
            date: makeDate(year: 2026, month: 1, day: 30, hour: 19, minute: 30),
            duration: 3,
            attendees: [
                InviteAttendee(user: UserData.ben, status: .yes),
                InviteAttendee(user: UserData.tim, status: .yes),
                InviteAttendee(user: UserData.anne, status: .yes),
                InviteAttendee(user: UserData.ruben, status: .no)
            ]
        )

        // MARK: - Die Liste für die App
        static let allInvites: [Invite] = [
            // Bestehende
            arbeiten1,
            arbeiten2,
            schrankEskalation,
            bouldern,
            urlaub,
            freetimeDev,
            
            
            morningSwim,
            longRide,
            trackIntervals,
            brickSession,
            zwiftRace,
            gymStrength,
            recoveryYoga,
            longRun,
            bikeFitting,
            triathlonMeetup
        ]
    }
