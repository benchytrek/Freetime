//
//  InviteView.swift
//  FreetimeRepo
//
//  Created by Ben Chytrek on 09.12.25.
//

import SwiftUI


struct InviteView: View {
    // Hier verbinden wir das ViewModel
    @State private var viewModel = InviteViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                // --- Sektion 1: User Bubbles (Horizontal) ---
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        // ForEach iteriert durch deine User im ViewModel
                        ForEach(viewModel.UserList) { user in
                            VStack {
                                Circle()
                                    .fill(Color.blue.opacity(0.4))
                                    .frame(width: 60, height: 60)
                                    .overlay(Text(user.name.prefix(1)).bold()) // Erster Buchstabe
                                
                                Text(user.name)
                                    .font(.caption)
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.top)
                
                Divider()
                
                // --- Sektion 2: Invite Liste (Vertikal) ---
                List(viewModel.InviteList) { invite in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(invite.titel)
                                .font(.headline)
                            Spacer()
                            // Datum formatieren (Apple Style)
                            Text(invite.date.formatted(.dateTime.weekday().hour().minute()))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Text(invite.description)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        // Kleine Vorschau der Teilnehmer
                        HStack {
                            ForEach(invite.attendees.prefix(3)) { attendee in
                                StatusCircle(status: attendee.status)
                            }
                            if invite.attendees.count > 3 {
                                Text("+\(invite.attendees.count - 3)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
                .listStyle(.plain) // Clean Look
            }
            .navigationTitle("Freetime")
        }
    }
}

// Kleine Hilfs-View für den Status-Punkt (UI Component)
struct StatusCircle: View {
    let status: InvitationAnswer
    
    var color: Color {
        switch status {
        case .yes: return .green
        case .no: return .red
        case .maybe: return .orange
        case .pending: return .gray
        }
    }
    
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 10, height: 10)
    }
}

#Preview {
    InviteView()
}
