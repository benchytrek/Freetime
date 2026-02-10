//
//  InviteModel.swift
//  FreetimeRepo
//
//  Created by Ben Chytrek on 09.12.25.
//

import Foundation
import FirebaseFirestore // Wichtig für @DocumentID falls gewünscht, aber hier manuell ok

// 1. Das Model für die Einladung
struct Invite: Identifiable, Codable {
    // Nutze String für IDs aus Firebase
    let id: String
    
    var titel: String
    var description: String
    var date: Date
    var duration: Int
    
    var attendees: [InviteAttendee]
    
    // WICHTIG: Wieder reinnehmen! Das brauchst du für die Query:
    // .whereField("participant_ids", arrayContains: currentUserID)
    var participant_ids: [String]
    
    // MARK: - Mapping Logik (CodingKeys)
    // Hier übersetzen wir "Firebase-Sprache" in "Swift-Sprache"
    enum CodingKeys: String, CodingKey {
        case id
        case titel = "Titel" // Firebase "Titel" -> Swift "titel"
        case description     // Wenn in DB fehlt, fangen wir das im init ab
        case date
        case duration
        case attendees
        case participant_ids
    }
    
    // Custom Decoder, um fehlende Felder abzufangen
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.titel = try container.decode(String.self, forKey: .titel)
        
        // Falls description in DB fehlt, nimm leeren String (verhindert Crash)
        self.description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        
        self.date = try container.decode(Date.self, forKey: .date)
        self.duration = try container.decode(Int.self, forKey: .duration)
        self.attendees = try container.decode([InviteAttendee].self, forKey: .attendees)
        self.participant_ids = try container.decodeIfPresent([String].self, forKey: .participant_ids) ?? []
    }
    
    // Standard Init für Mocks und Erstellung
    init(id: String, titel: String, description: String, date: Date, duration: Int, attendees: [InviteAttendee], participant_ids: [String]) {
        self.id = id
        self.titel = titel
        self.description = description
        self.date = date
        self.duration = duration
        self.attendees = attendees
        self.participant_ids = participant_ids
    }
}

// 2. Der Attendee (Teilnehmer)
struct InviteAttendee: Identifiable, Codable {
    var id: String { user.id }
    
    let user: User
    var status: InvitationAnswer
    
    // Mapping für die flache Firebase-Struktur
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case status
    }
    
    // Custom Decoding: Wir bauen das User-Objekt aus den flachen Daten zusammen
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let id = try container.decode(String.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        let statusString = try container.decode(String.self, forKey: .status)
        
        // User zusammenbauen (Email fehlt hier, ist aber für die Anzeige der Invites meist egal)
        self.user = User(id: id, name: name, email: "")
        self.status = InvitationAnswer(rawValue: statusString) ?? .pending
    }
    
    // Init für manuelles Erstellen
    init(user: User, status: InvitationAnswer) {
        self.user = user
        self.status = status
    }
    
    // Custom Encoding: Wenn wir speichern, wollen wir es wieder flach haben?
    // Fürs Erste lassen wir Swift das Standard-Encoding machen oder passen es bei Bedarf an "setData" an.
}

// 3. Das Enum für die Antwort
enum InvitationAnswer: String, Codable, CaseIterable {
    case yes
    case no
    case maybe
    case pending // Default
}

// MARK: - MOCK DATA (Extension)
extension Invite {
    static let mockInvite = Invite(
        id: "mock_invite_1",
        titel: "Bouldern & Sauna",
        description: "Wichtig: Handtuch nicht vergessen!",
        date: Date(),
        duration: 3600, // 1 Stunde
        attendees: [
            InviteAttendee(user: User.mockUser, status: .yes),
            InviteAttendee(user: User(id: "uid_2", name: "Philip", email: "p@test.de"), status: .maybe)
        ],
        participant_ids: ["test_user_1", "uid_2"]
    )
    
    static let mockInvites: [Invite] = [
        mockInvite,
        Invite(
            id: "mock_invite_2",
            titel: "Projekt Coding",
            description: "Freetime App fertig machen",
            date: Date().addingTimeInterval(86400), // Morgen
            duration: 7200,
            attendees: [InviteAttendee(user: User.mockUser, status: .yes)],
            participant_ids: ["test_user_1"]
        )
    ]
}
