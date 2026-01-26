//
//  InviteModel.swift
//  FreetimeRepo
//
//  Created by Ben Chytrek on 09.12.25.
//

import Foundation

// 1. Das Model für die Einladung
struct Invite: Identifiable, Codable {
    let id: String
    var titel: String
    var description: String
    var date: Date
    var duration: Int
    
    var attendees: [InviteAttendee]
    
    //var participant_ids: [String] vielleicht grosse problem mit dem bruder 
}

struct InviteAttendee: Identifiable, Codable {
    var id: String { user.id }
    
    let user: User
    var status: InvitationAnswer
}

// 3. Das Enum für die Antwort
enum InvitationAnswer: String, Codable, CaseIterable {
    case yes
    case no
    case maybe
    case pending // Default
}
