import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import Observation

@Observable
class UserManager {
    var currentUser: User?
    var isAuthenticated: Bool = false
    // NEU: Steuert, ob wir zum Profil-Setup müssen
    var isProfileComplete: Bool = true
    
    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?

    init() {
        Auth.auth().addStateDidChangeListener { [weak self] auth, firebaseUser in
            guard let self = self else { return }
            
            if let firebaseUser = firebaseUser {
                self.isAuthenticated = true
                self.fetchUserProfile(uid: firebaseUser.uid)
            } else {
                self.isAuthenticated = false
                self.currentUser = nil
                self.isProfileComplete = true // Reset
                self.listener?.remove()
            }
        }
    }
    
    private func fetchUserProfile(uid: String) {
        listener = db.collection("users").document(uid).addSnapshotListener { snapshot, error in
            // Wenn das Dokument NICHT existiert, müssen wir das Profil erstellen
            if let document = snapshot, !document.exists {
                print("⚠️ User eingeloggt, aber kein Profil gefunden -> Setup starten")
                self.isProfileComplete = false
                return
            }
            
            guard let document = snapshot, document.exists, let data = document.data() else { return }
            
            let username = data["username"] as? String ?? "Unbekannt"
            let userId = document.documentID
            self.currentUser = User(id: userId, name: username)
            
            // Profil ist da!
            self.isProfileComplete = true
        }
    }
    
    func signOut() {
        try? Auth.auth().signOut()
    }
}

