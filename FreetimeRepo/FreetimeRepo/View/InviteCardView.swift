//
//  InviteCardView.swift
//  FreetimeRepo
//
//  Created by Ben Chytrek on 09.12.25.
//

import SwiftUI

struct InviteCardView: View {
    let invite: Invite
    
    var body: some View {
        HStack(spacing: 16) {
            
            // 1. LINKER BEREICH: Host Avatar (Groß)
            // Da wir noch keine Bilder haben, nutzen wir Initialen
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 60, height: 60)
                .overlay(
                    // Zeigt den ersten Buchstaben des Titels als "Host" Dummy
                    Text(invite.titel.prefix(1))
                        .font(.title2.bold())
                        .foregroundStyle(.secondary)
                )
                // Optional: Falls du echte Bilder hast:
                // AsyncImage(url: invite.host.avatarURL) ...
            
            // 2. MITTLERER BEREICH: Info & Time Bar
            VStack(alignment: .leading, spacing: 6) {
                Text(invite.titel)
                    .font(.headline) // Fett gedruckt wie im Bild "Laufen"
                    .lineLimit(1)
                
                // Der Time-Bar (Grüner Balken im grauen Feld)
                ZStack(alignment: .leading) {
                    // Hintergrund (Grau)
                    Capsule()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 8)
                    
                    // Füllung (Grün) - Dummy Wert 60% gefüllt
                    Capsule()
                        .fill(Color.green)
                        .frame(width: 10, height: 8) // Statisch für Demo, später dynamisch berechnen
                }
                
                // Zeit Text (z.B. "17:00 - 18:00")
                Text("\(invite.date.formatted(date: .omitted, time: .shortened)) - \(invite.date.addingTimeInterval(3600).formatted(date: .omitted, time: .shortened))")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            // 3. RECHTER BEREICH: Gestapelte Avatare mit Status-Rahmen
            HStack(spacing: -12) { // Negatives Spacing sorgt für den Überlappungs-Effekt
                ForEach(invite.attendees.prefix(3)) { attendee in
                    UserAvatar(attendee: attendee)
                }
                
                // Falls mehr als 3 Leute kommen, zeige "+X"
                if invite.attendees.count > 3 {
                    Circle()
                        .fill(Color(.systemGray5))
                        .frame(width: 32, height: 32)
                        .overlay(
                            Text("+\(invite.attendees.count - 3)")
                                .font(.caption2.bold())
                        )
                        .overlay(Circle().stroke(Color(.systemBackground), lineWidth: 2))
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground)) // Das helle Grau der Karte
        .clipShape(RoundedRectangle(cornerRadius: 16)) // Runde Ecken
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2) // Leichter Schatten
    }
}

// Hilfs-View für die runden Avatare mit Rahmen
struct UserAvatar: View {
    let attendee: InviteAttendee
    
    // Logik für die Rahmenfarbe
    var statusColor: Color {
        switch attendee.status {
        case .yes: return .green
        case .no: return .red
        case .maybe: return .orange
        case .pending: return .gray.opacity(0.3)
        }
    }
    
    var body: some View {
        ZStack {
            // Hintergrund (Avatar)
            Circle()
                .fill(Color.blue.opacity(0.2))
                .frame(width: 32, height: 32)
                .overlay(
                    Text(attendee.user.name.prefix(1)) // Initiale
                        .font(.caption.bold())
                        .foregroundStyle(.blue)
                )
            
            // Der Status-Rahmen (Ring)
            Circle()
                .strokeBorder(statusColor, lineWidth: 2) // Hier ist die Logik!
                .frame(width: 32, height: 32)
        }
        // Weißer Rand außenrum, damit sie sich beim Überlappen sauber trennen
        .background(Circle().fill(Color(.systemBackground)).frame(width: 36, height: 36))
    }
}

// Preview, damit du es sofort siehst
#Preview {
    InviteCardView(invite: Invite(
        id: UUID(),
        titel: "Laufen",
        description: "Test",
        date: Date(),
        attendees: [
            InviteAttendee(user: User(id: UUID(), name: "Ben"), status: .yes),
            InviteAttendee(user: User(id: UUID(), name: "Anna"), status: .no),
            InviteAttendee(user: User(id: UUID(), name: "Tom"), status: .maybe)
        ]
    ))
    .padding()
}
