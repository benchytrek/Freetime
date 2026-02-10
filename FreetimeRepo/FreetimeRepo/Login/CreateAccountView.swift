import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct CreateAccountView: View {
    @State private var username = ""
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text("Dein Profil")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                    .padding(.top, 50)
                
                // Avatar Platzhalter (Später Foto-Upload)
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 100, height: 100)
                    .overlay(Image(systemName: "camera").foregroundStyle(.white))
                    .overlay(Circle().stroke(.white, lineWidth: 2))
                
                // Username Feld
                TextField("Benutzername", text: $username)
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(12)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 40)
                    .multilineTextAlignment(.center)
                
                Button(action: saveProfile) {
                    if isLoading {
                        ProgressView()
                    } else {
                        Text("Fertigstellen")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundStyle(.white)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 40)
                .disabled(username.isEmpty)
                
                Spacer()
            }
        }
    }
    
    func saveProfile() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        isLoading = true
        
        let db = Firestore.firestore()
        let userData: [String: Any] = [
            "id": uid,
            "username": username,
            "email": Auth.auth().currentUser?.email ?? "",
            "createdAt": FieldValue.serverTimestamp()
        ]
        
        db.collection("users").document(uid).setData(userData) { error in
            isLoading = false
            if error == nil {
                // Sobald das Dokument gespeichert ist, springt der UserManager
                // auf isProfileComplete = true und die App zeigt die Invites.
            }
        }
    }
}
