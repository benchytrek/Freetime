import Foundation
import SwiftUI
import Observation

@MainActor
@Observable
class InviteViewModel {
    
    var UserList: [User] = []
    var InviteList: [Invite] = []
    
    init() {
        loadData()
    }
    
    func loadData() {
        self.UserList = UserData.allUsers
        // Wir sortieren direkt nach Datum, damit das neue Event richtig einsortiert wird
        self.InviteList = InviteData.allInvites.sorted(by: { $0.date < $1.date })
    }
    
    // MARK: - Actions
    
    func createInvite(title: String, description: String, date: Date, durationHours: Int, selectedUserIds: Set<UUID>) {
        
        // 1. Die passenden User Objekte finden anhand der IDs
        // Wir setzen den Status für den Ersteller auf .yes, für alle anderen auf .pending
        var attendees: [InviteAttendee] = []
        
        // Der aktuelle User (Du) ist immer dabei
        let me = UserData.ben // Hardcoded für MVP, später dynamisch
        attendees.append(InviteAttendee(user: me, status: .yes))
        
        // Die ausgewählten Freunde hinzufügen
        let friends = UserData.allUsers.filter { selectedUserIds.contains($0.id) }
        for friend in friends {
            attendees.append(InviteAttendee(user: friend, status: .pending))
        }
        
        // 2. Neues Invite Objekt bauen
        let newInvite = Invite(
            id: UUID(),
            titel: title,
            description: description,
            date: date,
            duration: durationHours,
            attendees: attendees
        )
        
        // 3. Zur Liste hinzufügen und neu sortieren
        // Wir fügen es hinzu und sortieren sofort neu, damit es an der richtigen Zeit-Stelle steht
        var currentList = self.InviteList
        currentList.append(newInvite)
        self.InviteList = currentList.sorted(by: { $0.date < $1.date })
        
        print("✅ Invite '\(title)' erstellt mit \(attendees.count) Teilnehmern.")
    }
}
