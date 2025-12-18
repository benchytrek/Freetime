import SwiftUI
internal import Combine

// MARK: - MODELS
struct CalendarEvent: Identifiable {
    let id = UUID()
    let title: String
    let timeRange: String
    let startTime: Date
    let duration: TimeInterval // in seconds
    let type: EventType
    let collaborators: [String] // Avatar URLs or Names
}

struct TodoItem: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String?
    let isCompleted: Bool
    let color: Color
}

enum EventType {
    case standard(color: Color)
    case freeSlot
}

// MARK: - VIEW MODEL
class CalendarViewModelTest: ObservableObject {
    @Published var selectedDate: Date = Date()
    @Published var events: [Int: [CalendarEvent]] = [:] // Key: Day index (0, 1, 2)
    @Published var todos: [TodoItem] = []
    
    init() {
        setupMockData()
    }
    
    private func setupMockData() {
        // Helper to create dates relative to now
        let calendar = Calendar.current
        let today = Date()
        
        // Mocking data based on your HTML design
        // Column 0 (Wednesday)
        let evt1 = CalendarEvent(title: "Design Sync", timeRange: "09:00 - 11:00", startTime: calendar.date(bySettingHour: 9, minute: 0, second: 0, of: today)!, duration: 7200, type: .standard(color: .blue), collaborators: [])
        let evt2 = CalendarEvent(title: "Client Call", timeRange: "14:30 - 15:30", startTime: calendar.date(bySettingHour: 14, minute: 30, second: 0, of: today)!, duration: 3600, type: .standard(color: .purple), collaborators: [])
        
        // Column 1 (Thursday - Selected)
        let evt3 = CalendarEvent(title: "Product Strategy", timeRange: "08:30 - 11:00", startTime: calendar.date(bySettingHour: 8, minute: 30, second: 0, of: today)!, duration: 9000, type: .standard(color: .indigo), collaborators: ["A", "B"])
        let evtFree = CalendarEvent(title: "Free", timeRange: "", startTime: calendar.date(bySettingHour: 12, minute: 0, second: 0, of: today)!, duration: 5400, type: .freeSlot, collaborators: [])
        let evt4 = CalendarEvent(title: "Gym Session", timeRange: "16:00 - 17:30", startTime: calendar.date(bySettingHour: 16, minute: 0, second: 0, of: today)!, duration: 5400, type: .standard(color: .green), collaborators: [])
        
        // Column 2 (Friday)
        let evt5 = CalendarEvent(title: "Review", timeRange: "10:00 - 11:00", startTime: calendar.date(bySettingHour: 10, minute: 0, second: 0, of: today)!, duration: 3600, type: .standard(color: .orange), collaborators: [])
        
        events = [
            0: [evt1, evt2],
            1: [evt3, evtFree, evt4],
            2: [evt5]
        ]
        
        todos = [
            TodoItem(title: "Prepare presentation slides", subtitle: "Due today", isCompleted: true, color: .purple),
            TodoItem(title: "Email marketing team", subtitle: nil, isCompleted: false, color: .gray)
        ]
    }
}

// MARK: - MAIN VIEW
struct FreetimeHomeView: View {
    @StateObject private var viewModel = CalendarViewModelTest()
    
    // Constants for layout
    let hourHeight: CGFloat = 60
    let startHour: Int = 8
    let endHour: Int = 22
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color(UIColor.systemBackground).ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header Section
                HeaderView()
                
                // Day Selector
                DaySelectorView()
                    .padding(.vertical, 10)
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // Calendar Grid
                        HStack(alignment: .top, spacing: 0) {
                            // Time Axis
                            TimeAxisView(start: startHour, end: endHour, height: hourHeight)
                                .frame(width: 40)
                            
                            // Days Columns
                            HStack(spacing: 8) {
                                DayColumnView(events: viewModel.events[0] ?? [], startHour: startHour, hourHeight: hourHeight)
                                DayColumnView(events: viewModel.events[1] ?? [], startHour: startHour, hourHeight: hourHeight, isSelected: true)
                                DayColumnView(events: viewModel.events[2] ?? [], startHour: startHour, hourHeight: hourHeight)
                                    .opacity(0.6) // Visual cue for future days from HTML
                            }
                            .padding(.trailing, 16)
                        }
                        .frame(height: CGFloat(endHour - startHour) * hourHeight + 50)
                        
                        // To-Dos Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("TODOS")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.secondary)
                                .padding(.leading)
                            
                            ForEach(viewModel.todos) { item in
                                TodoRowView(item: item)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 100) // Space for floating tab bar
                    }
                }
            }
            
            // Floating Tab Bar
            FloatingTabBar()
                .padding(.bottom, 20)
        }
    }
}

// MARK: - SUBVIEWS

struct HeaderView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("CALENDAR")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                HStack {
                    Text("April 2025")
                        .font(.title2)
                        .fontWeight(.bold)
                    Image(systemName: "chevron.right")
                        .foregroundColor(.purple)
                }
            }
            Spacer()
            // Placeholder for User Profile/Avatar
             Circle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 36, height: 36)
                .overlay(Text("BN").font(.caption).fontWeight(.bold))
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }
}

struct DaySelectorView: View {
    let days = [
        ("Wed", "20", false),
        ("Thu", "21", true),
        ("Fri", "22", false),
        ("Sat", "23", false)
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(days.indices, id: \.self) { index in
                VStack(spacing: 4) {
                    Text(days[index].0.uppercased())
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                    
                    ZStack {
                        if days[index].2 {
                            Circle()
                                .fill(Color.purple.opacity(0.15))
                                .frame(width: 36, height: 36)
                        }
                        Text(days[index].1)
                            .font(.headline)
                            .foregroundColor(days[index].2 ? .purple : .primary)
                    }
                }
                .frame(maxWidth: .infinity)
                .opacity(index == 3 ? 0.5 : 1.0)
            }
        }
        .padding(.vertical, 8)
        .background(Color(UIColor.systemBackground))
        .overlay(Divider(), alignment: .bottom)
    }
}

struct TimeAxisView: View {
    let start: Int
    let end: Int
    let height: CGFloat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(start..<end + 1, id: \.self) { hour in
                Text("\(hour)")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .frame(height: height, alignment: .top)
                    .offset(y: -6) // Align with grid line
            }
        }
    }
}

struct DayColumnView: View {
    let events: [CalendarEvent]
    let startHour: Int
    let hourHeight: CGFloat
    var isSelected: Bool = false
    
    var body: some View {
        ZStack(alignment: .top) {
            // Background Grid Lines
            VStack(spacing: 0) {
                ForEach(0..<15) { _ in
                    Divider()
                        .frame(height: hourHeight, alignment: .top)
                }
            }
            
            // Events Layer
            ForEach(events) { event in
                EventCard(event: event)
                    .frame(height: calculateHeight(duration: event.duration))
                    .offset(y: calculateOffset(startTime: event.startTime))
                    .padding(.horizontal, 2)
            }
        }
        .background(isSelected ? Color.purple.opacity(0.02) : Color.clear)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.purple.opacity(0.3) : Color.clear, lineWidth: 1)
        )
    }
    
    // Helper to calculate Y position based on time
    func calculateOffset(startTime: Date) -> CGFloat {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: startTime)
        let minute = calendar.component(.minute, from: startTime)
        
        let relativeHour = CGFloat(hour - startHour)
        let relativeMinute = CGFloat(minute) / 60.0
        
        return (relativeHour + relativeMinute) * hourHeight
    }
    
    func calculateHeight(duration: TimeInterval) -> CGFloat {
        return CGFloat(duration / 3600) * hourHeight
    }
}

struct EventCard: View {
    let event: CalendarEvent
    
    var body: some View {
        switch event.type {
        case .standard(let color):
            VStack(alignment: .leading, spacing: 2) {
                Text(event.timeRange)
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(color)
                Text(event.title)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(2)
                
                if !event.collaborators.isEmpty {
                    HStack(spacing: -4) {
                        ForEach(0..<2) { _ in
                            Circle()
                                .fill(Color.gray)
                                .frame(width: 14, height: 14)
                                .overlay(Circle().stroke(Color.white, lineWidth: 1))
                        }
                    }
                    .padding(.top, 4)
                }
            }
            .padding(8)
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .background(color.opacity(0.1))
            .cornerRadius(12)
            .overlay(
                Rectangle()
                    .fill(color)
                    .frame(width: 3)
                    .cornerRadius(1.5),
                alignment: .leading
            )
            
        case .freeSlot:
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.4), style: StrokeStyle(lineWidth: 1, dash: [4]))
                
                Text("FREE")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                    .textCase(.uppercase)
            }
        }
    }
}

struct TodoRowView: View {
    let item: TodoItem
    
    var body: some View {
        HStack {
            if item.isCompleted {
                Circle()
                    .stroke(item.color, lineWidth: 2)
                    .frame(width: 18, height: 18)
                    .overlay(Circle().fill(item.color).frame(width: 10, height: 10))
            } else {
                Circle()
                    .stroke(Color.gray.opacity(0.5), lineWidth: 2)
                    .frame(width: 18, height: 18)
            }
            
            VStack(alignment: .leading) {
                Text(item.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                if let sub = item.subtitle {
                    Text(sub)
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            }
            Spacer()
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(16)
        .padding(.horizontal, 4)
    }
}

struct FloatingTabBar: View {
    var body: some View {
        HStack(spacing: 40) {
            TabBarItem(icon: "envelope", text: "Invites")
            
            VStack(spacing: 4) {
                Image(systemName: "calendar")
                    .font(.system(size: 24))
                    .foregroundColor(.purple)
                Text("Calendar")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.purple)
            }
            
            TabBarItem(icon: "person", text: "Profile")
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial) // Apple HIG Glassmorphism
        .cornerRadius(30)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

struct TabBarItem: View {
    let icon: String
    let text: String
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundColor(.gray)
            Text(text)
                .font(.caption2)
                .fontWeight(.medium)
                .foregroundColor(.gray)
        }
    }
}

// MARK: - PREVIEW
struct FreetimeHomeView_Previews: PreviewProvider {
    static var previews: some View {
        FreetimeHomeView()
            .preferredColorScheme(.light)
        FreetimeHomeView()
            .preferredColorScheme(.dark)
    }
}
