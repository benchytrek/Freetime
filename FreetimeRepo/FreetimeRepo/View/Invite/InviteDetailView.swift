//
//  InviteDetailView.swift
//  FreetimeRepo
//
//  Created by Ben Chytrek on 11.12.25.
//

import SwiftUI

struct InviteDetailView: View {
    let invite: Invite
    
    // Umgebungsvariable, um das Sheet schließen zu können
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // 1. HEADER: Titel & Host
                    HStack(alignment: .center, spacing: 16) {
                        // Host Avatar (Groß)
                        ZStack {
                            Circle()
                                .fill(Color.blue.opacity(0.1))
                                .frame(width: 64, height: 64)
                            
                            // Wir nehmen an, der erste in der Liste ist der Host oder nutzen den ersten Buchstaben des Titels als Placeholder
                            Text(invite.titel.prefix(1))
                                .font(.title.bold())
                                .foregroundStyle(.blue)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(invite.titel)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text(invite.description)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                    }
                    
                    // 2. ACTION BUTTONS (Yes / No / Maybe)
                    HStack(spacing: 12) {
                        Button(action: { /* Logik für Zusage */ }) {
                            Text("Yes")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.green)
                                .clipShape(Capsule())
                        }
                        
                        Button(action: { /* Logik für Absage */ }) {
                            Text("No")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.red)
                                .clipShape(Capsule())
                        }
                    }
                    
                    Button(action: { /* Logik für Vielleicht */ }) {
                        Text("Maybe")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.orange)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(Color.orange.opacity(0.15))
                            .clipShape(Capsule())
                    }
                    
                    Divider()
                    
                    // 3. ZEIT & DATUM INFO
                    VStack(alignment: .leading, spacing: 8) {
                        Label {
                            Text(invite.date.formatted(date: .complete, time: .omitted))
                                .fontWeight(.medium)
                        } icon: {
                            Image(systemName: "calendar")
                                .foregroundStyle(.blue)
                        }
                        
                        Label {
                            Text("\(invite.date.formatted(date: .omitted, time: .shortened)) - \(invite.date.addingTimeInterval(3600).formatted(date: .omitted, time: .shortened))")
                                .foregroundStyle(.secondary)
                        } icon: {
                            Image(systemName: "clock")
                                .foregroundStyle(.gray)
                        }
                    }
                    .font(.body)
                    
                    Divider()
                    
                    // 4. TEILNEHMER LISTE
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Attendees (\(invite.attendees.count))")
                            .font(.headline)
                        
                        ForEach(invite.attendees) { attendee in
                            HStack {
                                UserAvatar(attendee: attendee) // Wiederverwendung deiner Avatar View
                                Text(attendee.user.name)
                                    .fontWeight(.medium)
                                Spacer()
                                StatusBadge(status: attendee.status)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    
                    // Platzhalter für Map/Route (für späteres Feature)
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.secondarySystemBackground))
                        .frame(height: 150)
                        .overlay(Text("📍 Map Placeholder").foregroundStyle(.secondary))
                    
                }
                .padding(20)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Ein kleiner Schließen-Button oben rechts ist Best Practice
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.gray.opacity(0.5))
                            .font(.title2)
                    }
                }
            }
        }
    }
}

// Kleiner Helper für den Status-Text rechts
struct StatusBadge: View {
    let status: InvitationAnswer
    var body: some View {
        Text(status.rawValue.capitalized)
            .font(.caption2.bold())
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color(.systemGray6))
            .clipShape(Capsule())
            .foregroundStyle(.secondary)
    }
}

#Preview {
    InviteDetailView(invite: InviteData.allInvites.first!)
}
