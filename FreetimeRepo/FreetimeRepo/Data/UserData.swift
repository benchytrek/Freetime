//
//  UserData.swift
//  FreetimeRepo
//
//  Created by Ben Chytrek on 10.12.25.
//

import Foundation

struct UserData {
    static let ben = User(id: "user_ben", name: "Ben")
    static let philip = User(id: "user_philip", name: "Philip")
    static let tim = User(id: "user_tim", name: "Tim")
    static let ruben = User(id: "user_ruben", name: "Ruben")
    
    static let allUsers: [User] = [ben, philip, tim, ruben]
}
