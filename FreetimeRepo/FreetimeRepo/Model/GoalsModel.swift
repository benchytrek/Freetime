//
//  GoalsModel.swift
//  FreetimeRepo
//
//  Created by Ben Chytrek on 10.01.26.
//

import Foundation

// Vorschlag: Für Firestore-Synchronisation der Ziele ebenfalls auf String umstellen.
struct Goals: Identifiable, Codable, Equatable {
    let id: String // Vorher UUID
    var name: String
    var tasks: [GoalTask]

    init(id: String, name: String, tasks: [GoalTask] = []) {
        self.id = id
        self.name = name
        self.tasks = tasks
    }
}

struct GoalTask: Identifiable, Codable, Equatable {
    let id: String // Vorher UUID
    var name: String
    var isCompleted: Bool
    var beschreibung: String?

    init(id: String, name: String, isCompleted: Bool = false, beschreibung: String? = nil) {
        self.id = id
        self.name = name
        self.isCompleted = isCompleted
        self.beschreibung = beschreibung
    }
}
