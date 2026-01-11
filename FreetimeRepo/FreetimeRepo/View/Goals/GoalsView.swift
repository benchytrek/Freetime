//
//  GoalsView.swift
//  FreetimeRepo
//
//  Created by Ben Chytrek on 10.01.26.
//

import SwiftUI

struct GoalsView: View {
    // Daten aus GoalsData.swift laden
    @State private var goals: [Goals] = sampleGoals
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    
                    ForEach($goals) { $goal in
                        // HIER IST DER KORRIGIERTE LINK:
                        // Wir rufen jetzt GoalsDetailView auf (die View, die den Swipe-Container enthält)
                        // und übergeben ihr die komplette Liste ($goals) + die ID des angeklickten Ziels.
                        NavigationLink(destination: GoalsDetailView(goals: $goals, selectedGoalID: goal.id)) {
                            GoalCard(goal: $goal)
                        }
                        .buttonStyle(PlainButtonStyle()) // Verhindert blaue Einfärbung des Links
                    }
                    
                }
                .padding()
            }
            .navigationTitle("Ziele")
            .background(Color(UIColor.systemGroupedBackground))
        }
    }
}

// MARK: - Einzelne Ziel-Karte (Bleibt wie vorher)
struct GoalCard: View {
    @Binding var goal: Goals
    
    // Berechnet den Fortschritt live anhand der Tasks
    var currentProgress: Double {
        guard !goal.tasks.isEmpty else { return 0.0 }
        let completedCount = goal.tasks.filter { $0.isCompleted }.count
        return Double(completedCount) / Double(goal.tasks.count)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // Header
            HStack {
                // Icon und Farbe werden über den Namen ermittelt
                Image(systemName: getIcon(name: goal.name))
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(10)
                    .background(getColor(name: goal.name))
                    .clipShape(Circle())
                
                VStack(alignment: .leading) {
                    Text(goal.name)
                        .font(.headline)
                        .foregroundColor(.primary) // Sicherstellen, dass Text schwarz bleibt im Link
                    Text("\(Int(currentProgress * 100))% erledigt")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
            
            // Fortschrittsbalken
            ProgressView(value: currentProgress)
                .progressViewStyle(LinearProgressViewStyle(tint: getColor(name: goal.name)))
            
            Divider()
            
            // Aufgaben-Liste (Vorschau: Zeigt nur die ersten 3 oder so)
            VStack(alignment: .leading, spacing: 8) {
                // Wir zeigen hier nur max 3 Tasks als Vorschau an, um die Karte nicht zu sprengen
                ForEach($goal.tasks.prefix(3)) { $task in
                    TaskRow(task: $task, color: getColor(name: goal.name))
                }
                if goal.tasks.count > 3 {
                    Text("+ \(goal.tasks.count - 3) weitere Aufgaben")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.leading, 36) // Einrückung passend zum Text darüber
                }
            }
        }
        .padding()
        // ÄNDERUNG: Dynamische Hintergrundfarbe für Dark Mode Support
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    func getIcon(name: String) -> String {
        if name.contains("Backflip") { return "figure.gymnastics" }
        if name.contains("Dev") { return "laptopcomputer" }
        return "target"
    }
    
    func getColor(name: String) -> Color {
        if name.contains("Backflip") { return .blue }
        if name.contains("Dev") { return .purple }
        return .green
    }
}

// MARK: - Einzelne Aufgaben Zeile (Für die Vorschau auf der Hauptseite)
struct TaskRow: View {
    @Binding var task: GoalTask
    var color: Color
    
    var body: some View {
        // Hier kein Button mehr, da die ganze Karte ein Link ist.
        // Oder wir nutzen .onTapGesture, um Konflikte zu vermeiden.
        // Einfachheitshalber zeigen wir es hier nur an.
        HStack(spacing: 12) {
            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                .font(.title3)
                .foregroundColor(task.isCompleted ? color : .gray)
            
            Text(task.name)
                .strikethrough(task.isCompleted)
                .foregroundColor(task.isCompleted ? .gray : .primary)
            
            Spacer()
        }
        .padding(.vertical, 2)
    }
}

struct GoalsView_Previews: PreviewProvider {
    static var previews: some View {
        GoalsView()
            .preferredColorScheme(.dark) // Vorschau im Dark Mode testen
    }
}
