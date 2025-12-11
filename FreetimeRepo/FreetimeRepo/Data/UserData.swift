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
    static let anna = User(id: UUID(), name: "Anna")
    static let tom = User(id: UUID(), name: "Tom")
    static let lisa = User(id: UUID(), name: "Lisa")
    static let max = User(id: UUID(), name: "Max")
    static let sarah = User(id: UUID(), name: "Sarah")
    static let chris = User(id: UUID(), name: "Chris")
    static let julia = User(id: UUID(), name: "Julia")
    static let david = User(id: UUID(), name: "David")
    static let laura = User(id: UUID(), name: "Laura")
    
    // Die Liste für deine horizontale ScrollView
    static let allUsers: [User] = [
        ben, anna, tom, lisa, max, sarah, chris, julia, david, laura
    ]
}
