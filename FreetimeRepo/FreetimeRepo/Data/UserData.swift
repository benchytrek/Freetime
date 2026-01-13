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
    
    static let allUsers: [User] = [
        ben, philip, tim, ruben, anne, tom, lena, ramonski, sophie, mama
    ]
    
    static let partyPeople: [User] = [
        User(id: UUID(), name: "Ali"), User(id: UUID(), name: "Bea"), User(id: UUID(), name: "Chris"),
        User(id: UUID(), name: "Dora"), User(id: UUID(), name: "Erik"), User(id: UUID(), name: "Fay"),
        User(id: UUID(), name: "Gino"), User(id: UUID(), name: "Hana"), User(id: UUID(), name: "Ivo"),
        User(id: UUID(), name: "Jana"), User(id: UUID(), name: "Kai"), User(id: UUID(), name: "Lea"),
        User(id: UUID(), name: "Mio"), User(id: UUID(), name: "Nia"), User(id: UUID(), name: "Ole"),
        User(id: UUID(), name: "Pia"), User(id: UUID(), name: "Quinn"), User(id: UUID(), name: "Ria"),
        User(id: UUID(), name: "Sam"), User(id: UUID(), name: "Tea"), User(id: UUID(), name: "Udo"),
        User(id: UUID(), name: "Vicky")
    ]
}
