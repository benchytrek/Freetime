//
//  CalendarInvite.swift
//  FreetimeRepo
//
//  Created by Ben Chytrek on 05.01.26.
//

import SwiftUI

struct CalendarInvite: View {
    let invite: Invite
    
    // State für die Detailansicht
    @State private var showDetails = false
    
    var body: some View {
        Button(action: {
            showDetails = true
        }) {
            ZStack(alignment: .topLeading) { // Inhalt oben links ausrichten
                
                // Hintergrund
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.green.opacity(0.6))
                    // HINWEIS: Annahme duration ist in Stunden (z.B. 2). Wenn Minuten, Formel anpassen.
                    .frame(width: 100, height: CGFloat(invite.duration) * 60)
                
                VStack(alignment: .leading, spacing: 6) {
                    
                    // 1. Titel (Oben links, max 2 Zeilen)
                    Text(invite.titel)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.black)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true) // Verhindert Abschneiden bei Umbruch
                    
                    // 2. Teilnehmer (Icons + Name)
                    if !invite.attendees.isEmpty {
                        HStack(spacing: -8) { // Überlappende Avatare für Platzersparnis (optional)
                            ForEach(invite.attendees.prefix(3)) { attendee in // Zeige max 3 an
                                VStack(spacing: 2) {
                                    // Avatar Placeholder (SF Symbol)
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.white)
                                        .background(Circle().fill(Color.black)) // Kontrast
                                    
                                    // Name
                                    Text(attendee.user.name)
                                        .font(.system(size: 8, weight: .medium))
                                        .foregroundColor(.black)
                                        .lineLimit(1)
                                        .frame(width: 30) // Begrenzte Breite für Text
                                }
                            }
                            
                            // "+X" Indikator wenn mehr als 3 Teilnehmer
                            if invite.attendees.count > 3 {
                                Text("+\(invite.attendees.count - 3)")
                                    .font(.caption2)
                                    .foregroundColor(.black)
                            }
                        }
                    }
                    
                    Spacer(minLength: 0) // Drückt Inhalt nach oben
                }
                .padding(8) // Innerer Abstand zum Rand
            }
        }
        .buttonStyle(PlainButtonStyle()) // Entfernt Standard-Button-Styling (wichtig in Listen)
        .sheet(isPresented: $showDetails) {
            // Zeigt die Detailansicht als Overlay
            InviteDetailView(invite: invite)
        }
    }
}

#Preview {
    // Nutzung der existierenden UserData für die Preview
    let mockInvite = Invite(
        id: "event-1",
        titel: "Projektplanung Freetime App",
        description: "Besprechung der Roadmap und Features.",
        date: Date(),
        duration: 2, 
        attendees: [
            InviteAttendee(user: UserData.ben, status: .yes),
            InviteAttendee(user: UserData.philip, status: .pending),
            InviteAttendee(user: UserData.tim, status: .maybe)
        ]
    )
    
    CalendarInvite(invite: mockInvite)
}
