import SwiftUI

struct ContentView: View {
    // Apple HIG empfiehlt: Verwende die AccentColor für den aktiven State,
    // um Brand-Consistency zu wahren.
    
    var body: some View {
        TabView {
            InviteView()
                .tabItem {
                    Label("Invites", systemImage: "person")
                }
            CalendarView()
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }
            GoalsView()
                .tabItem {
                    Label("Goals", systemImage: "target")
                }
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
        }//lol
        .tint(Color.accentColor)
    }
}

#Preview {
    ContentView()
}
