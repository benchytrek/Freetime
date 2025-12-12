import SwiftUI

struct ContentView: View {
    // Apple HIG empfiehlt: Verwende die AccentColor für den aktiven State,
    // um Brand-Consistency zu wahren.
    
    var body: some View {
        TabView {
            // Tab 1: Invites (Deine Hauptfunktion)
            InviteView()
                .tabItem {
                    // SF Symbols sind Vektorgrafiken von Apple.
                    // 'envelope' ist der Standard für Einladungen/Nachrichten.
                    Label("Invites", systemImage: "envelope.fill")
                }
            
            // Tab 2: Test / SwipeDownTest (Für deine Entwicklung)
            SwipDownTest()
                .tabItem {
                    // 'hammer.fill' oder 'gear' signalisiert klar:
                    // Hier wird gebaut/getestet.
                    Label("Test", systemImage: "hammer.fill")
                }
            HapticTest()
                .tabItem {
                    Label("Haptic", systemImage: "hand.draw.fill")
                }
        }
        // Ein kleiner 'tint' sorgt für das moderne iOS-Feeling passend zu deiner CI
        // Definiert in deinen Assets als 'AccentColor'[cite: 42].
        .tint(Color.accentColor)
    }
}

#Preview {
    ContentView()
}
