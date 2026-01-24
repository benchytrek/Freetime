import SwiftUI

struct InviteCreateView: View {
    @Environment(\.dismiss) var dismiss
    
    // UI State
    @State private var title: String = ""
    @FocusState private var isTitleFocused: Bool
    
    // Set für die Auswahl der User IDs
    @State private var selectedUserIds: Set<UUID> = []
    
    // Zugriff auf die Mock-Daten aus deinem Projekt
    private let allUsers = UserData.allUsers
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                // 1. Hintergrund (System Style)
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                    .onTapGesture { isTitleFocused = false }
                
                ScrollView {
                    VStack(spacing: 32) {
                        
                        // 2. Titel Input (Liquid Glass Container)
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.ultraThinMaterial)
                                .frame(height: 64)
                                .shadow(color: .black.opacity(0.05), radius: 10, y: 4)
                            
                            TextField("Was geht ab?", text: $title)
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                                .multilineTextAlignment(.center)
                                .focused($isTitleFocused)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        // 3. Freunde Auswahl (Horizontaler HStack)
                        VStack(alignment: .leading, spacing: 12) {
                            Text("FREUNDE WÄHLEN")
                                .font(.caption.bold())
                                .foregroundStyle(.secondary)
                                .padding(.horizontal, 25)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(allUsers) { user in
                                        UserSelectionCircle(
                                            user: user,
                                            isSelected: selectedUserIds.contains(user.id)
                                        ) {
                                            toggleUser(user.id)
                                        }
                                    }
                                }
                                .padding(.horizontal, 25)
                            }
                        }
                        
                        // 4. Zeit auswahlen
                        ZStack() {
                            Rectangle()
                                .fill(Color.blue.opacity(0.1))
                                .frame(height: 100)
                            Text("Zeit auswählen")// soll immer links stehen
                                .font(.caption.bold())
                            
                        }
                        ZStack{
                            Rectangle()
                                .fill(Color.green.opacity(0.3))//
                                .frame(width: 100, height: 300)
                            // 5. Eingeladen Sektion (Vertikale Liste wie im Bild)
                            if !selectedUserIds.isEmpty {
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("INVITED FRIENDS")
                                        .font(.caption.bold())
                                        .foregroundStyle(.secondary)
                                        .padding(.horizontal, 25)
                                    
                                    VStack(spacing: 12) {
                                        ForEach(allUsers.filter { selectedUserIds.contains($0.id) }) { user in
                                            InvitedUserRow(user: user)
                                                .transition(.asymmetric(
                                                    insertion: .move(edge: .leading).combined(with: .opacity),
                                                    removal: .opacity
                                                ))
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                }
                            }}
                        
                        Spacer(minLength: 50)
                    }
                }
            }
            .navigationTitle("New Invite")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") { dismiss() }
                        .foregroundStyle(.primary)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Erstellen") {
                        // Hier käme die Logik zum Speichern ins ViewModel
                        dismiss()
                    }
                    .fontWeight(.bold)
                    .disabled(title.isEmpty)
                }
            }
            .onAppear {
                // Focus Delay für smoothes Keyboard-Erscheinen
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    isTitleFocused = true
                }
            }
        }
    }
    
    // Logik zum Hinzufügen/Entfernen
    private func toggleUser(_ id: UUID) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            if selectedUserIds.contains(id) {
                selectedUserIds.remove(id)
            } else {
                selectedUserIds.insert(id)
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            }
        }
    }
}

// MARK: - Subviews

struct UserSelectionCircle: View {
    let user: User
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.accentColor : Color.gray.opacity(0.1))
                        .frame(width: 60, height: 60)
                    
                    Text(user.name.prefix(1))
                        .font(.headline)
                        .foregroundStyle(isSelected ? .white : .primary)
                    
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.white, Color.accentColor)
                            .background(Circle().fill(.white))
                            .offset(x: 22, y: -22)
                    }
                }
                Text(user.name)
                    .font(.caption2)
                    .foregroundStyle(isSelected ? .primary : .secondary)
            }
        }
        .buttonStyle(.plain)
    }
}

struct InvitedUserRow: View {
    let user: User
    
    var body: some View {
        HStack(spacing: 16) {
            // Avatar
            Circle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 44, height: 44)
                .overlay(
                    Text(user.name.prefix(1))
                        .font(.system(size: 16, weight: .bold))
                )
            VStack(alignment: .leading, spacing: 4){
                Text(user.name)
                    .font(Font.caption.bold())
                    
                    
                AvailabilityBar()
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 40)
        //.background(.ultraThinMaterial)
        //.clipShape(RoundedRectangle(cornerRadius: 20))
        //.overlay(
        //    RoundedRectangle(cornerRadius: 20)
        //        .stroke(.primary.opacity(0.05), lineWidth: 0.5)
        //)
    }
}
struct AvailabilityBar: View {
    // Konfiguration für den Tag (8:00 - 22:00 Uhr)
    private let startHour: Double = 8.0
    private let endHour: Double = 22.0
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 4) {
            
            GeometryReader { proxy in
                let totalWidth = proxy.size.width
                let pixelsPerHour = totalWidth / (endHour - startHour)
                
                // Wir simulieren hier "Besetzt"-Zeiten (Busy Slots)
                // Später kommen diese Daten aus dem CalendarEngine
                let busySlots: [(start: Double, duration: Double)] = [
                    (start: 8.0, duration: 8.0),
                    (start: 17.0, duration: 1.0),
                    (start: 18.5, duration: 1.0)
                ]
                
                ZStack(alignment: .leading) {
                    // Hintergrund (Der "freie" Tag)
                    Capsule()
                        .fill(Color.green.opacity(0.5))
                        .frame(height: 8)
                    
                    // "Busy" Markierungen (Orange/Rot statt grün, da es belegte Zeit darstellt)
                    ForEach(0..<busySlots.count, id: \.self) { index in
                        let slot = busySlots[index]
                        let xPos = (slot.start - startHour) * pixelsPerHour
                        let width = slot.duration * pixelsPerHour
                        
                        Capsule()
                            .fill(Color.red.opacity(1.0))
                            .frame(width: max(0, width), height: 8)
                            .offset(x: max(0, xPos))
                    }
                }
            }
            .frame(height: 8)
        }
    }
}

// MARK: - Previews

#Preview("Light Mode") {
    InviteCreateView()
}

#Preview("Dark Mode") {
    InviteCreateView()
        .preferredColorScheme(.dark)
}
