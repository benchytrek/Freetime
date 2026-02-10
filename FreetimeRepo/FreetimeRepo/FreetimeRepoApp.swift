import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
}

@main
struct FreetimeRepoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // Initialisiere den Manager erst NACH Firebase.configure()
    @State private var userManager: UserManager

    init() {
        FirebaseApp.configure()
        _userManager = State(initialValue: UserManager())
    }

    var body: some Scene {
        WindowGroup {
            Group {
                // 1. Eingeloggt & Profil fertig -> App Inhalt
                if userManager.isAuthenticated && userManager.isProfileComplete {
                    ContentView()
                        .transition(.opacity)
                }
                // 2. Eingeloggt, aber Profil fehlt -> Profil Setup
                else if userManager.isAuthenticated && !userManager.isProfileComplete {
                    CreateAccountView()
                        .transition(.move(edge: .bottom))
                }
                // 3. Nicht eingeloggt -> Login/Register
                else {
                    AuthView()
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut, value: userManager.isAuthenticated)
            .animation(.easeInOut, value: userManager.isProfileComplete)
            .environment(userManager)
            .preferredColorScheme(.dark)
        }
    }
}
