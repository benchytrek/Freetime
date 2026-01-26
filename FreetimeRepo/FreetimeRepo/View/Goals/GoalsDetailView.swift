import SwiftUI

// MARK: - GoalsDetailView (Swipe + Detail kombiniert)
struct GoalsDetailView: View {
    @Binding var goals: [Goals]       // Alle Ziele (fürs Swipen)
    
    // FIX: Typ auf String geändert (war vorher UUID)
    @State var selectedGoalID: String
    
    var body: some View {
        // 1. Der Swipe-Container (TabView)
        TabView(selection: $selectedGoalID) {
            
            // Wir gehen durch alle Ziele...
            ForEach($goals) { $goal in
                
                // 2. ... und zeigen für jedes Ziel direkt die ScrollView an
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        
                        // Fortschrittsanzeige Text
                        HStack {
                            // Berechneter Wert direkt im Text
                            let progress = goal.tasks.isEmpty ? 0.0 : Double(goal.tasks.filter { $0.isCompleted }.count) / Double(goal.tasks.count)
                            Text("\(Int(progress * 100))% completed")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .bold()
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.top, 20) // Etwas Abstand nach oben zum Header
                        
                        // Die Timeline (Aufgaben)
                        HStack(alignment: .top, spacing: 0) {
                            
                            // Liste der Tasks
                            LazyVStack(alignment: .leading, spacing: 0) {
                                
                                // WICHTIG: Wir holen uns hier die Indizes als Array, drehen sie um
                                // und iterieren dann darüber. Das ist für den Compiler einfacher.
                                let indices = Array(0..<goal.tasks.count).reversed()
                                
                                ForEach(indices, id: \.self) { index in
                                    // Zugriff auf das Binding über den Index
                                    // isLast: index == 0 bedeutet, es ist der unterste Task (Start)
                                    GoalTaskRow(task: $goal.tasks[index], isLast: index == 0)
                                }
                            }
                        }
                        .padding()
                    }
                }
                .tag(goal.id) // WICHTIG: Verbindet das Ziel mit der TabView-Selection
                // DIES IST DER SCHLÜSSEL FÜR DEN STICKY HEADER:
                // Wir setzen den NavigationTitle DYNAMISCH auf das aktuelle Ziel in der Schleife
                .navigationTitle(goal.name)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never)) // Swipe-Effekt ohne Punkte
        .background(Color(UIColor.systemBackground))
        // .large sorgt dafür, dass der Titel groß startet und beim Scrollen oben klein "einrastet" (sticky)
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Helper Views (TaskRow & TaskCard)
// Diese bleiben als kleine Bausteine erhalten, damit der Code oben übersichtlich bleibt.

private struct GoalTaskRow: View {
    @Binding var task: GoalTask
    let isLast: Bool // Wenn true (ganz unten), kein Strich nach unten
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            
            // TIMELINE SPALTE
            VStack(spacing: 0) {
                // Der Punkt
                Circle()
                    .fill(task.isCompleted ? Color.blue : Color.gray)
                    .frame(width: 16, height: 16)
                    .background(
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                            .shadow(radius: 1)
                    )
                    .zIndex(1)
                
                // Die Linie nach unten
                if !isLast {
                    Rectangle()
                        .fill(task.isCompleted ? Color.blue : Color.gray.opacity(0.3))
                        .frame(width: 4)
                        .frame(maxHeight: .infinity)
                        .padding(.top, -2)
                }
            }
            .frame(width: 20)
            
            // KARTE SPALTE
            GoalTaskCard(task: $task)
                .padding(.bottom, 24)
        }
        .fixedSize(horizontal: false, vertical: true)
    }
}

private struct GoalTaskCard: View {
    @Binding var task: GoalTask
    
    var body: some View {
        Button(action: {
            withAnimation(.spring()) {
                task.isCompleted.toggle()
            }
        }) {
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(task.isCompleted ? Color.blue : Color(UIColor.secondarySystemBackground))
                    .cornerRadius(16)
                    .frame(minHeight: 60)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(task.name)
                        .font(.headline)
                        .foregroundColor(task.isCompleted ? .white : .primary)
                        .strikethrough(task.isCompleted)
                    
                    if let beschreibung = task.beschreibung {
                        Text(beschreibung)
                            .font(.caption)
                            .foregroundColor(task.isCompleted ? .white.opacity(0.8) : .secondary)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                    }
                }
                .padding()
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview
struct GoalsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView { // Navigation View in Preview simulieren, um Title zu sehen
            StateWrapper()
        }
    }
    
    struct StateWrapper: View {
        @State var goals = sampleGoals
        var body: some View {
            // FIX: sampleGoals hat jetzt String IDs, das passt also automatisch
            GoalsDetailView(goals: $goals, selectedGoalID: goals[0].id)
        }
    }
}
