//
//  UserModel.swift
//  FreetimeRepo
//
//  Created by Ben Chytrek on 09.12.25.
//

import Foundation

// Public Person
struct User: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let email: String // Neu hinzugefügt
    
    //let avatarURL: String
}

// MARK: - MOCK DATA (Für Previews)
// Das schreibst du nur HIER. Alle anderen Dateien greifen darauf zu.
extension User {
    static let mockUser = User(
        id: "test_user_1",
        name: "Ben (Preview)",
        email: "ben@test.de"
    )
    
    static let mockUsers: [User] = [
        User(id: "test_user_1", name: "Ben", email: "ben@test.de"),
        User(id: "test_user_2", name: "Anna", email: "anna@test.de"),
        User(id: "test_user_3", name: "Tom", email: "tom@test.de")
    ]
}
