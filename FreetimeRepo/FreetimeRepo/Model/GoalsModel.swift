//
//  GoalsModel.swift
//  FreetimeRepo
//
//  Created by Ben Chytrek on 10.01.26.
//

import Foundation

struct Goals: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var tasks: [GoalTask] // "tasks" als Mehrzahl ist klarer
    
    // Kleiner Helfer für die Initialisierung
    init(id: UUID = UUID(), name: String, tasks: [GoalTask] = []) {
        self.id = id
        self.name = name
        self.tasks = tasks
    }
}

struct GoalTask: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var isCompleted: Bool
    var beschreibung: String? // Optional, falls mal keine Beschreibung da ist
    
    // Initializer mit Standardwerten
    init(id: UUID = UUID(), name: String, isCompleted: Bool = false, beschreibung: String? = nil) {
        self.id = id
        self.name = name
        self.isCompleted = isCompleted
        self.beschreibung = beschreibung
    }
}
