import Foundation
import SwiftUI
import Observation
import FirebaseFirestore

@MainActor
@Observable
class InviteViewModel {
    
    var UserList: [User] = []
    var InviteList: [Invite] = []
    
    // Referenz auf die Firestore-Datenbank
    private let db = Firestore.firestore()
    // Speicher für den Listener, damit wir ihn bei Bedarf stoppen können
    private nonisolated(unsafe) var listener: ListenerRegistration?
    
    init() {
        loadData()
    }
    
    func loadData() {
        // 1. Statische User-Daten (vorerst weiterhin aus MockData)
        self.UserList = UserData.allUsers
        
        // 2. Firebase Listener auf die "events" Collection
        // Wir filtern nach 'participant_ids', um nur Events zu sehen, bei denen du dabei bist.
        // Hardcoded für den MVP: wir nutzen "user_ben" (später Auth UID)
        let currentUserID = "user_ben"
        
        listener = db.collection("events")
            .whereField("participant_ids", arrayContains: currentUserID)
            .addSnapshotListener { [weak self] querySnapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("❌ Fehler beim Laden der Invites: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else { return }
                
                // Nutzt das 'Codable' Protokoll von Firebase, um Docs in Invite-Objekte zu wandeln
                self.InviteList = documents.compactMap { queryDocumentSnapshot -> Invite? in
                    try? queryDocumentSnapshot.data(as: Invite.self)
                }.sorted(by: { $0.date < $1.date })
                
                print("✅ \(self.InviteList.count) Invites live aus Firebase geladen.")
            }
    }
    
    // MARK: - Actions
    
    func createInvite(title: String, description: String, date: Date, durationHours: Int, selectedUserIds: Set<String>) {
        // Hier folgt als nächstes die Logik, um ein Dokument in Firebase zu SPEICHERN
        // (setData anstatt nur lokal zum Array hinzufügen)
    }
    
    deinit {
        // Stoppt den Listener, wenn das ViewModel zerstört wird
        listener?.remove()
    }
}
