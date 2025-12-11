//
//  InviteViewModel.swift
//  FreetimeRepo
//
//  Created by Ben Chytrek on 09.12.25.
//

import Foundation
import SwiftUI
import Observation

@MainActor
@Observable
class InviteViewModel {
    
    // Die Listen, die unsere View beobachtet
    var UserList: [User] = []
    var InviteList: [Invite] = []
    
    init() {
        loadData()
    }
    
    // Lädt die Daten aus unseren neuen Data-Files
    func loadData() {
        self.UserList = UserData.allUsers
        self.InviteList = InviteData.allInvites
    }
}
