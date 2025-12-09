//
//  InviteModel.swift
//  FreetimeRepo
//
//  Created by Ben Chytrek on 09.12.25.
//

import Foundation

// 1. Das Model für die Einladung
struct Invite: Identifiable, Codable {
    let id: UUID
    var title: String        // "titel" -> Englisch ist Standard in Swift
    var description: String
    var date: Date
    
    // Anstatt list<tuple>, nutzen wir ein Array von Custom Structs
    var attendees: [InviteAttendee]
}

// 2. Der "Wrapper", der User und Antwort verbindet (statt Tuple)
struct InviteAttendee: Identifiable, Codable {
    // Wir nutzen die User-ID als ID, damit SwiftUI die Liste managen kann
    var id: UUID { user.id }
    
    let user: User
    var status: InvitationAnswer // Umbenannt von "answer", Typen schreibt man groß
}

// 3. Das Enum für die Antwort
enum InvitationAnswer: String, Codable, CaseIterable {
    case yes
    case no
    case maybe
    case pending // Wichtig: Ein Default-Status, wenn noch nicht geantwortet wurde
}
