import SwiftUI

struct InviteCreateView: View {
    @Environment(\.dismiss) var dismiss
    
    // UI State
    @State private var title: String = ""
    @FocusState private var isTitleFocused: Bool
    
    // Zeit-Auswahl State
    @State private var startTime: Double = 13.0 // Startzeit (z.B. 13:00)
    @State private var duration: Double = 1.0  // Dauer in Stunden (0.5 bis 10.0)
    
    // Set für die Auswahl der User IDs
    @State private var selectedUserIds: Set<UUID> = []
    
    // Zugriff auf die Mock-Daten
    private let allUsers = UserData.allUsers
    
    // Konfiguration für die Zeitachse (8:00 - 22:00 Uhr = 14 Stunden)
    private let startHour: Double = 8.0
    private let endHour: Double = 22.0
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                    .onTapGesture { isTitleFocused = false }
                
                ScrollView {
                    VStack(spacing: 24) {
                        
                        // 1. Titel Input
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.ultraThinMaterial)
                                .frame(height: 64)
                                .shadow(color: .black.opacity(0.05), radius: 10, y: 4)
                            
                            TextField("Was geht ab?", text: $title)
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .multilineTextAlignment(.center)
                                .focused($isTitleFocused)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        // 2. Freunde Auswahl
                        ZStack {
                            RoundedRectangle(cornerRadius: 24)
                                .fill(.ultraThinMaterial)
                                .frame(width: 300, height: 100)
                            
                            VStack(alignment: .leading, spacing: 12) {
                                
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
                                    //.padding(.horizontal, 25) // Removed horizontal padding as per instructions
                                }.frame(width: 300)
                                    // gib mir scroll transitions
                                
                            }
                            .padding(20)
                        }
                        
                        // 3. Dauer Slider
                        VStack(spacing: 12) {
                            HStack {
                                
                                Text(formatDuration(duration))
                                    .font(.system(.title, design: .rounded).bold())
                                    .foregroundStyle(.teal)
                            }
                            
                            ZStack {
                                
                                
                                Slider(value: $duration, in: 0.01...4.0, step: 0.01)
                                    .tint(.teal)
                                    .frame(width: 200)
                            }
                            .frame(height: 10)

                        }
                        
                        // 4. Interaktive Zeit-Vorschau
                        VStack(alignment: .center, spacing: 16) {
                            HStack {
                                
                                Text("\(formatTime(startTime)) - \(formatTime(startTime + duration))")
                                    .font(.system(.title, design: .rounded).bold())
                                    .foregroundStyle(.teal)
                            }
                            .padding(.horizontal, 25)
                            
                            GeometryReader { mainProxy in
                                let barAreaWidth = max(50, mainProxy.size.width - 80)
                                
                                ZStack(alignment: .trailing) {
                                    VStack(spacing: 0) {
                                        if !selectedUserIds.isEmpty {
                                            ForEach(allUsers.filter { selectedUserIds.contains($0.id) }) { user in
                                                InvitedUserRow(user: user, barAreaWidth: barAreaWidth)
                                            }
                                        }
                                    }
                                    
                                    if !selectedUserIds.isEmpty {
                                        TimeSelectorOverlay(
                                            startTime: $startTime,
                                            duration: duration,
                                            totalWidth: barAreaWidth,
                                            startHour: startHour,
                                            endHour: endHour
                                        )
                                        .padding(.trailing, 16)
                                    }
                                }
                            }
                            .frame(height: CGFloat(max(1, selectedUserIds.count)) * 72 + 20)
                        }
                        
                        Spacer(minLength: 50)
                    }
                }
            }
            .navigationTitle("New Invite")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") { dismiss() }.foregroundStyle(.primary)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Erstellen") { dismiss() }
                        .fontWeight(.bold)
                        .disabled(title.isEmpty)
                }
            }
        }
    }
    
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
    
    private func formatTime(_ value: Double) -> String {
        let totalMinutes = Int(value * 60)
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        return String(format: "%02d:%02d", hours, minutes)
    }

    private func formatDuration(_ value: Double) -> String {
        let hours = Int(value)
        let mins = Int((value - Double(hours)) * 60)
        if mins == 0 { return "\(hours)h" }
        return "\(hours)h \(mins)m"
    }
}

// MARK: - Subviews

struct TimeSelectorOverlay: View {
    @Binding var startTime: Double
    let duration: Double
    let totalWidth: CGFloat
    let startHour: Double
    let endHour: Double
    
    @State private var dragInitialStartTime: Double? = nil
    
    var body: some View {
        GeometryReader { _ in
            let pixelsPerHour = totalWidth / (endHour - startHour)
            let selectorWidth = duration * pixelsPerHour
            let currentX = (startTime - startHour) * pixelsPerHour
            
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.green.opacity(0.35))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.green.opacity(0.6), lineWidth: 2)
                )
                .frame(width: selectorWidth)
                .offset(x: currentX)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if dragInitialStartTime == nil {
                                dragInitialStartTime = startTime
                            }
                            let deltaHours = Double(value.translation.width / pixelsPerHour)
                            let newTime = (dragInitialStartTime ?? startTime) + deltaHours
                            startTime = max(startHour, min(endHour - duration, newTime))
                        }
                        .onEnded { _ in
                            startTime = snapToInterestingPoints(startTime)
                            dragInitialStartTime = nil
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        }
                )
        }
        .frame(width: totalWidth)
    }
    
    private func snapToInterestingPoints(_ time: Double) -> Double {
        let snapThreshold = 0.2
        var snappedTime = (time * 4).rounded() / 4
        let busyEdges = [8.0, 12.0, 17.0, 18.0, 18.5, 19.5]
        for edge in busyEdges {
            if abs(time - edge) < snapThreshold { snappedTime = edge }
            if abs((time + duration) - edge) < snapThreshold { snappedTime = edge - duration }
        }
        return max(startHour, min(endHour - duration, snappedTime))
    }
}

struct InvitedUserRow: View {
    let user: User
    let barAreaWidth: CGFloat
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 44, height: 44)
                .overlay(Text(user.name.prefix(1)).font(.system(size: 16, weight: .bold)))
            
            VStack(alignment: .leading, spacing: 6) {
                Text(user.name).font(.system(size: 14, weight: .bold)).foregroundStyle(.primary)
                AvailabilityBar().frame(width: barAreaWidth).frame(height: 8)
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .frame(height: 72)
    }
}

struct AvailabilityBar: View {
    private let startHour: Double = 8.0
    private let endHour: Double = 22.0
    var body: some View {
        GeometryReader { proxy in
            let totalWidth = proxy.size.width
            let pixelsPerHour = totalWidth / (endHour - startHour)
            let busySlots: [(start: Double, duration: Double)] = [
                (start: 8.0, duration: 4.0),
                (start: 17.0, duration: 1.0),
                (start: 18.5, duration: 1.0)
            ]
            ZStack(alignment: .leading) {
                Capsule().fill(Color.green.opacity(0.4)).frame(height: 8)
                ForEach(0..<busySlots.count, id: \.self) { index in
                    let slot = busySlots[index]
                    let xPos = (slot.start - startHour) * pixelsPerHour
                    let width = slot.duration * pixelsPerHour
                    Capsule().fill(Color.red.opacity(1.0)).frame(width: max(0, width), height: 8).offset(x: max(0, xPos))
                }
            }
        }
    }
}

struct UserSelectionCircle: View {
    let user: User
    let isSelected: Bool
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    Circle().fill(isSelected ? Color.accentColor : Color.gray.opacity(0.1)).frame(width: 60, height: 60)
                    Text(user.name.prefix(1)).font(.headline).foregroundStyle(isSelected ? .white : .primary)
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill").foregroundStyle(.white, Color.accentColor).background(Circle().fill(.white)).offset(x: 22, y: -22)
                    }
                }
                Text(user.name).font(.caption2).foregroundStyle(isSelected ? .primary : .secondary)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview("Light Mode") {
    InviteCreateView()
}

