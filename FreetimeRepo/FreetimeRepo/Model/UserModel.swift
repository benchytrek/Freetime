//
//  UserModel.swift
//  FreetimeRepo
//
//  Created by Ben Chytrek on 09.12.25.
//

import Foundation

//Public Person

struct User: Identifiable, Codable {
    let id: UUID
    let name: String
    
    
    //let avatarURL: String
    //let calender: String
    
}
