//
//  InviteViewModel.swift
//  FreetimeRepo
//
//  Created by Ben Chytrek on 09.12.25.
//

import Foundation
import SwiftUI
import Observation

// @MainActor sorgt dafür, dass UI-Updates immer auf dem Haupt-Thread passieren
@MainActor
@Observable
class InviteViewModel {
    
    // Liste
    var UserList: [User] = []
    var InviteList: [Invite] = []
    
    init() {
        loadDummyData()
    }
    
    func loadDummyData() {
        // Mock Users
        let ben = User(id: UUID(), name: "Ben")
        let anna = User(id: UUID(), name: "Anna")
        let tom = User(id: UUID(), name: "Tom")
        
        self.UserList = [ben, anna, tom]
        
        // Mock Invites
        let pizzaAbend = Invite(
            id: UUID(),
            titel: "Pizza Abend",
            description: "Lust auf Pizzeria Napoli?",
            date: Date().addingTimeInterval(3600 * 5), // Heute + 5 Std
            attendees: [
                InviteAttendee(user: ben, status: .yes),
                InviteAttendee(user: anna, status: .pending),
                InviteAttendee(user: tom, status: .maybe)
            ]
        )
        
        let gymSession = Invite(
            id: UUID(),
            titel: "Gym Session",
            description: "Leg Day! Wer ist dabei?",
            date: Date().addingTimeInterval(86400), // Morgen
            attendees: [
                InviteAttendee(user: ben, status: .yes),
                InviteAttendee(user: tom, status: .yes)
            ]
        )
        
        self.InviteList = [pizzaAbend, gymSession]
    }
}
