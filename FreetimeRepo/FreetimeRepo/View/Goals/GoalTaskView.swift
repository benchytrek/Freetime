//
//  GoalTaskView.swift
//  FreetimeRepo
//
//  Created by Ben Chytrek on 10.01.26.
//

import SwiftUI

struct GoalTaskView: View {
    // 1. Hier definieren wir: Diese View braucht EINE Aufgabe, um zu funktionieren
    let task: GoalTask
    
    var body: some View {
        VStack {
            // Kreis (Timeline Punkt)
            Circle()
                // 2. Zugriff: Wenn task.isCompleted wahr ist -> Blau, sonst Grau
                .foregroundColor(task.isCompleted ? .blue : .gray)
                .frame(width: 10, height: 10)
            
            ZStack {
                // Hintergrund-Karte
                Rectangle()
                    .foregroundColor(task.isCompleted ? .blue : .gray)
                    .frame(width: 200, height: 30)
                    .cornerRadius(20)
                
                // Name der Aufgabe
                Text(task.name) // 3. Zugriff auf den Namen
                    .font(.title3) // .title ist oft zu groß für Listen, title3 passt besser
                    .bold()
                    .foregroundColor(.white) // Text auf farbigem Grund besser weiß
                    .padding()
            }
        }
    }
}

// MARK: - Preview
struct GoalTaskView_Previews: PreviewProvider {
    static var previews: some View {
        // Für die Vorschau erstellen wir eine Dummy-Aufgabe oder nehmen eine aus den Daten
        VStack {
            // Beispiel 2: Offene Aufgabe
            GoalTaskView(task: GoalTask(name: "Landung üben", isCompleted: false))
            // Beispiel 1: Erledigte Aufgabe
            GoalTaskView(task: GoalTask(name: "Backflip stehen", isCompleted: true))
            
            
        }
    }
}
