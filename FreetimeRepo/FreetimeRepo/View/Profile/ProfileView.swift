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
                
                SettingsView()
                
                
            }
            .navigationTitle("Profil")
        }
    }
}

#Preview {
    ProfileView()
}
