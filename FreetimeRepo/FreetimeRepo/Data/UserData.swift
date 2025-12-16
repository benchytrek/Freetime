//
//  UserData.swift
//  FreetimeRepo
//
//  Created by Ben Chytrek on 10.12.25.
//

import Foundation

struct UserData {
    // Wir definieren die User einzeln, damit wir sie gleich in den Invites gezielt nutzen können
    static let ben = User(id: UUID(), name: "Ben")
    static let philip = User(id: UUID(), name: "Philip")
    static let tim = User(id: UUID(), name: "Tim")
    static let ruben = User(id: UUID(), name: "Ruben")
    static let anne = User(id: UUID(), name: "Anne")
    static let tom = User(id: UUID(), name: "Tom")
    static let lena = User(id: UUID(), name: "Lena")
    static let ramonski = User(id: UUID(), name: "Ramonski")
    static let sophie = User(id: UUID(), name: "Sophie")
    static let mama = User(id: UUID(), name: "Mama")
    
    // Die Liste für deine horizontale ScrollView
    static let allUsers: [User] = [
        ben, philip, tim, ruben, anne, tom, lena, ramonski, sophie, mama
    ]
}
