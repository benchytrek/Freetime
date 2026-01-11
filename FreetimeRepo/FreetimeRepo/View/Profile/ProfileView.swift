//
//  ProfileView.swift
//  FreetimeRepo
//
//  Created by Ben Chytrek on 11.01.26.
//

import SwiftUI

struct ProfileView: View {
    // Mock User - später kommt das aus dem UserViewModel
    let user = UserData.ben
    
    var body: some View {
        NavigationStack {
            List {
                // MARK: - Header Section
                Section {
                    HStack(spacing: 16) {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 70, height: 70)
                            .overlay(
                                Text(user.name.prefix(1))
                                    .font(.title.bold())
                                    .foregroundStyle(.secondary)
                            )
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(user.name)
                                .font(.title2)
                                .fontWeight(.semibold)
                            Text("wer das liest ist dumm")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                // MARK: - Friends Section
                // Social Proof ist wichtig für Ihre App. Zeigen Sie die Freunde prominent.
                Section(header: Text("Meine Crew")) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            // Kleiner 'Add' Button am Anfang
                            VStack {
                                Circle()
                                    .strokeBorder(Color.accentColor, lineWidth: 2)
                                    .frame(width: 50, height: 50)
                                    
                                Text("Add")
                                    .font(.caption)
                            }
                            
                            // Mock Freunde Liste
                            ForEach(UserData.allUsers.prefix(5)) { friend in
                                VStack {
                                    Circle()
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(width: 50, height: 50)
                                        .overlay(Text(friend.name.prefix(1)).font(.caption.bold()))
                                    Text(friend.name)
                                        .font(.caption)
                                        .lineLimit(1)
                                }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                
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
                Section {
                    Button(action: {
                        // Logout Logic
                    }) {
                        Text("Abmelden")
                            .foregroundStyle(.red)
                    }
                } footer: {
                    Text("Freetime v1.0.0 (Build 42)")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top)
                }
            }
            .navigationTitle("Profil")
        }
    }
}

#Preview {
    ProfileView()
}
