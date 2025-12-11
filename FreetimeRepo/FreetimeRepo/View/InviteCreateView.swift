//
//  InviteCreateView.swift
//  FreetimeRepo
//
//  Created by Ben Chytrek on 11.12.25.
//

import SwiftUI

struct InviteCreateView: View {
    @Environment(\.dismiss) var dismiss
    
    // Form States
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var selectedDate: Date = Date()
    @State private var selectedDuration: TimeInterval = 3600 // 1 Stunde
    
    var body: some View {
        NavigationStack {
            Form {
                // Sektion 1: Was?
                Section(header: Text("Details")) {
                    TextField("Titel (z.B. Pizza essen)", text: $title)
                        .font(.headline)
                    
                    TextField("Beschreibung", text: $description, axis: .vertical)
                        .lineLimit(3...5)
                }
                
                // Sektion 2: Wann?
                Section(header: Text("Zeitplan")) {
                    DatePicker("Startzeit", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                    
                    Picker("Dauer", selection: $selectedDuration) {
                        Text("1 Stunde").tag(3600.0)
                        Text("2 Stunden").tag(7200.0)
                        Text("Open End").tag(0.0)
                    }
                }
                
                // Sektion 3: Wer? (Hier später Friends-Picker einbauen)
                Section(header: Text("Einladen")) {
                    Button(action: {}) {
                        Label("Freunde hinzufügen", systemImage: "person.badge.plus")
                    }
                }
            }
            .navigationTitle("New Invite")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") { dismiss() }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Erstellen") {
                        // TODO: Logik zum Speichern
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                    .fontWeight(.bold)
                }
            }
        }
    }
}

#Preview {
    InviteCreateView()
}
