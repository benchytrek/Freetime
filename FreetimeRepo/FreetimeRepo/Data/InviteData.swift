//
//  InviteData.swift
//  FreetimeRepo
//
//  Created by Ben Chytrek on 10.12.25.
//

import Foundation

struct InviteData {
    static let schrankEskalation = Invite(
        id: "event-1", // Vorher UUID()
        titel: "Schrank Eskalation",
        description: "Lass mal unten auflegen",
        date: Date(),
        duration: 2,
        attendees: [
            InviteAttendee(user: UserData.ben, status: .yes)
        ]
    )
    
    static let allInvites: [Invite] = [schrankEskalation]
}
