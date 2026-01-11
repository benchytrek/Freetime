//
//  SettingsView.swift
//  FreetimeRepo
//
//  Created by Ben Chytrek on 11.01.26.
//

import SwiftUI

struct SettingsView: View {
    // Wir nutzen hier 'Group', damit die Sections direkt in die parent-List der ProfileView integriert werden.
    // KEIN NavigationStack und KEINE List hier!
    var body: some View {
        Group {
            // MARK: - Calendar Settings
            Section(header: Text("Kalender & Sync")) {
                NavigationLink(destination: Text("Apple Calender oder Google Calender verbinden")) {
                    Label("Sync", systemImage: "calendar.badge.plus")
                }
                
                NavigationLink(destination: Text("Wie wird dein Calender welchen freunden angezeitgt?")) {
                    Label("Show", systemImage: "eye.fill")
                }
                
                NavigationLink(destination: Text("dinger die du immer wieder machst oder schneller invites erstellen")) {
                    Label("Custom Invites/Event/Task", systemImage: "document.fill")
                }
            }
            
            // MARK: - App Settings
            Section(header: Text("Allgemein")) {
                NavigationLink(destination: Text("Benachrichtigungen")) {
                    Label("Mitteilungen", systemImage: "bell.fill")
                }
                
                NavigationLink(destination: Text("Privatsphäre")) {
                    Label("Datenschutz", systemImage: "hand.raised.fill")
                }
            }
            
            // MARK: - Footer
            // Footer Syntax korrigiert
            Section {
                Button(action: {
                    // Logout Logic
                }) {
                    Text("Abmelden")
                        .foregroundStyle(.red)
                }
            } footer: {
                Text("Freetime v1.0.0 (Ben Chytrek)")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top)
            }
        }
    }
}

#Preview {
    // Für die Preview müssen wir eine List simulieren
    NavigationStack{
        List {
            SettingsView()
        }
    }
}
