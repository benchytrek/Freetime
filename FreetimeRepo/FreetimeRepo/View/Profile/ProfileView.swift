//
//  ProfileView.swift
//  FreetimeRepo
//
//  Created by Ben Chytrek on 09.12.25.
//

import SwiftUI

struct ProfileView: View {
    // Zugriff auf den zentralen Manager
    @Environment(UserManager.self) private var userManager
    
    var body: some View {
        NavigationStack {
            List {
                // MARK: - Header Section
                Section {
                    HStack(spacing: 16) {
                        // Avatar (Initialen)
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 70, height: 70)
                            .overlay(
                                // Zeige den ersten Buchstaben des ECHTEN Namens (oder "?" wenn noch geladen wird)
                                Text(userManager.currentUser?.name.prefix(1) ?? "?")
                                    .font(.title.bold())
                                    .foregroundStyle(.secondary)
                            )
                        
                        VStack(alignment: .leading, spacing: 4) {
                            // ECHTER NAME aus Firestore
                            Text(userManager.currentUser?.name ?? "Lade Profil...")
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            // ECHTE EMAIL aus Firebase Auth
                            Text(userManager.authUserEmail ?? "E-Mail wird geladen...")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .accentColor(.cyan) // Damit man sieht, dass es aktiv ist
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                // MARK: - Navigation Buttons
                Section(header: Text("Account Actions")) {
                    Button(role: .destructive, action: {
                        userManager.signOut()
                    }) {
                        HStack {
                            Text("Logout")
                            Spacer()
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                        }
                    }
                }
                
                // MARK: - Friends Section (Mock für jetzt)
                Section(header: Text("Meine Crew")) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            // Add Button
                            VStack {
                                Circle()
                                    .strokeBorder(Color.accentColor, lineWidth: 2)
                                    .frame(width: 50, height: 50)
                                    .overlay(Image(systemName: "plus").foregroundStyle(.cyan))
                                Text("Add").font(.caption)
                            }
                            
                            // Platzhalter für Freunde (Das machen wir nächste Woche dynamisch)
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
                
                SettingsView()
            }
            .navigationTitle("Profil")
        }
    }
}

#Preview {
    // Für die Preview müssen wir einen Dummy-Manager simulieren
    ProfileView()
        .environment(UserManager())
}
