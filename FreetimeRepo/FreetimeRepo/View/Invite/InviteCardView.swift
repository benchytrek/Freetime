//
//  InviteCardView.swift
//  FreetimeRepo
//
//  Created by Ben Chytrek on 09.12.25.
//

import SwiftUI

struct InviteCardView: View {
    let invite: Invite
    
    // --- KONFIGURATION ---
    // Unsere Timeline geht von 8 bis 22 Uhr (14 Stunden)
    private let startHour: Double = 8.0
    private let endHour: Double = 22.0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // --- OBERER BEREICH: Host, Titel & Avatare ---
            // (Bleibt genau so clean wie vorher)
            HStack(alignment: .top) {
                
                // 1. Host Bild
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Text(invite.titel.prefix(1))
                            .font(.title3.bold())
                            .foregroundStyle(.secondary)
                    )
                
                // 2. Text Infos
                VStack(alignment: .leading, spacing: 4) {
                    Text(invite.titel)
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                    
                    Text(invite.description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                // 3. Avatare
                HStack(spacing: -12) {
                    ForEach(invite.attendees.prefix(3)) { attendee in
                        UserAvatar(attendee: attendee)
                    }
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
            
            // --- UNTERER BEREICH: Smarte Time Bar ---
            VStack(alignment: .trailing, spacing: 1) {
                
                // Uhrzeit Text
                Text("\(invite.date.formatted(date: .omitted, time: .shortened)) - \(invite.date.addingTimeInterval(3600).formatted(date: .omitted, time: .shortened))")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                
                // Logik-Wrapper für den Balken
                GeometryReader { proxy in
                    // 1. Wie breit ist die ganze Box in Pixeln?
                    let totalWidth = proxy.size.width
                    
                    // 2. Wie breit ist EINE Stunde in Pixeln?
                    // Gesamtzeit = 22 - 8 = 14 Stunden
                    let pixelsPerHour = totalWidth / (endHour - startHour)
                    
                    // 3. Wann startet das Event? (z.B. 13:30 Uhr)
                    let calendar = Calendar.current
                    let eventHour = Double(calendar.component(.hour, from: invite.date))
                    let eventMinute = Double(calendar.component(.minute, from: invite.date)) / 60.0
                    let eventTime = eventHour + eventMinute
                    
                    // 4. Offset berechnen: Wie viele Stunden nach 8 Uhr geht es los?
                    // "max(0, ...)" verhindert Fehler, falls ein Termin mal um 7 Uhr ist
                    let offsetHours = max(0, eventTime - startHour)
                    let xPosition = offsetHours * pixelsPerHour
                    
                    // 5. Breite berechnen: Dauer * PixelProStunde
                    // Aktuell nehmen wir statisch 1 Stunde an (1.0)
                    let eventDuration = 1.0
                    let width = eventDuration * pixelsPerHour
                    
                    ZStack(alignment: .leading) {
                        // Hintergrund (8-22 Uhr)
                        Capsule()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 8)
                        
                        // Meeting Balken (Grün)
                        Capsule()
                            .fill(Color.green)
                            .frame(width: CGFloat(invite.duration * 20), height: 6) // Dynamische Breite
                            .offset(x: xPosition)           // Dynamische Position
                    }
                }
                .frame(height: 8) // WICHTIG: Begrenzt die Höhe des GeometryReaders
            }
        }
        .padding(16)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

// Helper für Avatar (bleibt gleich)
struct UserAvatar: View {
    let attendee: InviteAttendee
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
            Circle()
                .fill(Color.blue.opacity(0.2))
                .frame(width: 32, height: 32)
                .overlay(Text(attendee.user.name.prefix(1)).font(.caption.bold()).foregroundStyle(.blue))
            Circle().strokeBorder(statusColor, lineWidth: 2).frame(width: 32, height: 32)
        }
        .background(Circle().fill(Color(.systemBackground)).frame(width: 36, height: 36))
    }
}

// Preview
#Preview {
    let ben = User(id: UUID(), name: "Ben")
    
    VStack(spacing: 20) {
        // Test 1: Früh am Morgen (Ganz links)
        InviteCardView(invite: Invite(
            id: UUID(),
            titel: "Titel",
            description: "Description",
            date: Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date())!,
            duration: 2,
            attendees: [InviteAttendee(user: ben, status: .yes)
                       // InviteAttendee(user: anna, status: .no)
                       ]
        ))
        
        // Test 2: Mitten am Tag (Mitte)
        InviteCardView(invite: Invite(
            id: UUID(),
            titel: "Mittagessen",
            description: "Pizza",
            date: Calendar.current.date(bySettingHour: 15, minute: 0, second: 0, of: Date())!,
            duration: 7, // 15 Uhr = 3 PM
            attendees: [InviteAttendee(user: ben, status: .yes)]
        ))
    }
    .padding()
}
