//
//  InviteData.swift
//  FreetimeRepo
//
//  Created by Ben Chytrek on 10.12.25.
//

import Foundation

struct InviteData {
    
    static let allInvites: [Invite] = [

        Invite(
            id: UUID(),
            titel: "Schrank Eskalation",
            description: "Lass mal unten auflegen",
            date: Date().addingTimeInterval(3600 * 2), // In 2 Std
            attendees: [
                InviteAttendee(user: UserData.ben, status: .yes),
                InviteAttendee(user: UserData.philip, status: .pending),
                InviteAttendee(user: UserData.tim, status: .maybe)
                InviteAttendee(user: UserData.ruben, status: .no)
            ]
        ),
        

        Invite(
            id: UUID(),
            titel: "Bouldern",
            description: "und Sauna, Wichtig",
            date: Date().addingTimeInterval(86400), // +1 Tag
            attendees: [
                InviteAttendee(user: UserData.ben, status: .yes),
                InviteAttendee(user: UserData.lena, status: .yes)
                InviteAttendee(user: UserData.philip, status: .no)
                InviteAttendee(user: UserData.ramonski, status: .no)
                InviteAttendee(user: UserData.sophie, status: .maybe)
                
            ]
        ),
        

        Invite(
            id: UUID(),
            titel: "Urlaub",
            description: "",
            date: Date().addingTimeInterval(86400 * 2), // +2 Tage
            attendees: [
                InviteAttendee(user: UserData.ben, status: .yes),
                InviteAttendee(user: UserData.lena, status: .maybe)
                InviteAttendee(user: UserData.philip, status: .yes)
            ]
        ),
        
        // 4. Lernen (Nur 1 Person)
        Invite(
            id: UUID(),
            titel: "Freetime Dev",
            description: "diggi weiter programmieren",
            date: Date().addingTimeInterval(3600 * 5),
            attendees: [
                InviteAttendee(user: UserData.ben, status: .yes)
            ]
        ),

    ]
}
