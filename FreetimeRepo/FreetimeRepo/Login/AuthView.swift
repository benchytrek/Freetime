import SwiftUI
import FirebaseAuth

struct AuthView: View {
    // Toggle State: Login oder Registrieren?
    @State private var isLoginMode = true
    
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var errorMessage = ""
    
    var body: some View {
        ZStack {
            // Hintergrund
            LinearGradient(colors: [.blue, .purple, .black], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text("Freetime")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(radius: 10)
                
                VStack(spacing: 20) {
                    // Header wechselt je nach Modus
                    Text(isLoginMode ? "Willkommen zurück" : "Account erstellen")
                        .font(.title2.bold())
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentTransition(.numericText()) // Coole Animation beim Wechsel
                    
                    VStack(spacing: 15) {
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(12)
                            .foregroundStyle(.white)
                        
                        SecureField("Passwort", text: $password)
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(12)
                            .foregroundStyle(.white)
                    }
                    
                    if !errorMessage.isEmpty {
                        Text(errorMessage).font(.caption).foregroundStyle(.red).bold()
                    }
                    
                    // DER BUTTON (Macht beides)
                    Button(action: handleAuthAction) {
                        HStack {
                            if isLoading { ProgressView().tint(.black) } else {
                                Text(isLoginMode ? "Einloggen" : "Weiter") // Bei Register heißt es "Weiter" zum Profil
                                    .fontWeight(.bold)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .foregroundStyle(.black)
                        .cornerRadius(15)
                    }
                    .disabled(isLoading || email.isEmpty || password.isEmpty)
                }
                .padding(30)
                .background(.ultraThinMaterial)
                .cornerRadius(30)
                
                // DER UMSCHALTER (Statt NavigationLink)
                Button {
                    withAnimation(.spring()) {
                        isLoginMode.toggle()
                        errorMessage = ""
                    }
                } label: {
                    HStack {
                        Text(isLoginMode ? "Noch keinen Account?" : "Bereits einen Account?")
                        Text(isLoginMode ? "Registrieren" : "Login")
                            .fontWeight(.bold)
                            .underline()
                    }
                    .foregroundColor(.white.opacity(0.9))
                }
            }
        }
    }
    
    func handleAuthAction() {
        isLoading = true
        errorMessage = ""
        
        if isLoginMode {
            // LOGIN LOGIK
            Auth.auth().signIn(withEmail: email, password: password) { _, error in
                isLoading = false
                if let error = error { errorMessage = error.localizedDescription }
            }
        } else {
            // REGISTRIERUNG LOGIK (Nur Account erstellen)
            Auth.auth().createUser(withEmail: email, password: password) { _, error in
                isLoading = false
                if let error = error {
                    errorMessage = error.localizedDescription
                } else {
                    // Erfolg!
                    // Der UserManager bemerkt jetzt: "Eingeloggt" -> YES, "Profil da?" -> NO.
                    // Die App schaltet automatisch auf CreateAccountView um.
                }
            }
        }
    }
}
