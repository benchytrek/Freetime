import SwiftUI

struct PouringUserGrid: View {
    struct HexUser: Identifiable {
        let id = UUID()
        let color: Color
        let index: Int
        let entranceOffset: CGSize
    }
    
    @State private var users: [HexUser] = []
    
    let iconSize: CGFloat = 50
    let spacing: CGFloat = 8
    let containerSize: CGFloat = 400
    
    @State private var validSlots: [CGPoint] = []
    
    var body: some View {
        VStack(spacing: 20) {
            
            // 1. DER GRID CONTAINER
            ZStack(alignment: .topLeading) {
                
                // Hintergrund-Kreis
                Circle()
                    .strokeBorder(Color.gray.opacity(0.2), lineWidth: 1)
                    .background(Circle().fill(Color.black.opacity(0.03)))
                    .frame(width: containerSize, height: containerSize)
                
                // Die User Icons
                ForEach(users) { user in
                    if user.index < validSlots.count {
                        let targetPos = validSlots[user.index]
                        
                        UserBubbleView(user: user, size: iconSize)
                            .position(x: targetPos.x, y: targetPos.y)
                            .transition(
                                .asymmetric(
                                    // OFFSET: Jetzt fliegen sie von viel weiter oben rein
                                    insertion: .offset(user.entranceOffset).combined(with: .opacity),
                                    removal: .scale
                                )
                            )
                            .zIndex(Double(users.count - user.index))
                    }
                }
            }
            .frame(width: containerSize, height: containerSize)
            // WICHTIG: .clipped() entfernt, damit sie "über den Rand" malen dürfen
            
            // WICHTIG: Statt .mask() nutzen wir ein Overlay für den unteren Fade.
            // Das schneidet oben nichts ab. (Nimmt SystemBackground an)
            .overlay(
                LinearGradient(
                    stops: [
                        .init(color: .clear, location: 0.85),
                        .init(color: Color(.systemBackground), location: 1.0)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                ),
                alignment: .bottom
            )
            .onAppear {
                self.validSlots = generateOvalSlots()
            }
            
            // 2. STEUERUNG
            HStack {
                Button(action: addUser) {
                    Label("Einen reinwerfen", systemImage: "arrow.down.circle.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                }
                .buttonStyle(.borderedProminent)
                .disabled(users.count >= validSlots.count)
                
                Button(action: addMany) {
                    Image(systemName: "square.stack.3d.down.forward.fill")
                        .padding()
                }
                .buttonStyle(.bordered)
                .disabled(users.count >= validSlots.count)
                
                Button(action: { withAnimation { users.removeAll() } }) {
                    Image(systemName: "trash")
                        .padding()
                        .foregroundStyle(.red)
                }
                .buttonStyle(.bordered)
            }
            .padding(.horizontal)
            
            Text("\(users.count) / \(validSlots.count) im Glas")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        // Z-Index für den ganzen Container setzen, damit die fliegenden Bälle
        // über anderen Elementen auf der Seite liegen
        .zIndex(1)
    }
    
    // MARK: - Logik
    
    func addUser() {
        guard users.count < validSlots.count else { return }
        
        let index = users.count
        let targetPos = validSlots[index]
        
        // Zufallswert drastisch erhöht (-600), damit sie vom Screen-Top kommen
        let randomStartX = CGFloat.random(in: -100...(containerSize + 100))
        let randomStartY = CGFloat.random(in: -600...(-200)) // Weit oben starten
        
        let offsetX = randomStartX - targetPos.x
        let offsetY = randomStartY - targetPos.y
        
        let color = Color(
            hue: .random(in: 0...1),
            saturation: 0.7,
            brightness: 0.9
        )
        
        let newUser = HexUser(
            color: color,
            index: index,
            entranceOffset: CGSize(width: offsetX, height: offsetY)
        )
        
        // Etwas langsamere Animation (0.6), damit man den Flug besser sieht
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
            users.append(newUser)
        }
    }
    
    func addMany() {
        for i in 0..<10 { // Mehr Action!
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.08) {
                addUser()
            }
        }
    }
    
    func generateOvalSlots() -> [CGPoint] {
        // (Logik bleibt identisch zum vorherigen Schritt)
        var slots: [CGPoint] = []
        let centerX = containerSize / 2
        let centerY = containerSize / 2
        let radius = (containerSize / 2) - (iconSize / 2)
        
        let hexHeight = iconSize * 0.85
        let hexWidth = iconSize + spacing
        
        let rows = Int(containerSize / hexHeight) + 2
        let cols = Int(containerSize / hexWidth) + 2
        
        for row in -1...rows {
            for col in -1...cols {
                var x = CGFloat(col) * hexWidth
                let y = CGFloat(row) * hexHeight
                if row % 2 != 0 { x += hexWidth / 2 }
                
                let finalX = x + 15
                let finalY = y + 20
                
                let dx = finalX - centerX
                let dy = finalY - centerY
                if sqrt(dx*dx + dy*dy) < radius {
                    slots.append(CGPoint(x: finalX, y: finalY))
                }
            }
        }
        
        return slots.sorted {
            if abs($0.y - $1.y) > 10 { return $0.y < $1.y }
            else { return $0.x < $1.x }
        }
    }
}

// (UserBubbleView bleibt gleich)
struct UserBubbleView: View {
    let user: PouringUserGrid.HexUser
    let size: CGFloat
    
    var body: some View {
        Circle()
            .fill(user.color)
            .frame(width: size, height: size)
            .overlay(
                Text("\(user.index + 1)")
                    .font(.caption2.bold())
                    .foregroundStyle(.white)
            )
            .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 2)
    }
}

#Preview {
    PouringUserGrid()
}
