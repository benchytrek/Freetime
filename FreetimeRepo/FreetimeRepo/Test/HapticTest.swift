import SwiftUI
import UIKit

struct HapticTest: View {
    
    var body: some View {
        NavigationView {
            List {
                // MARK: - Impact Feedback
                // Simuliert physische Stöße oder Einrast-Punkte
                Section(header: Text("Impact (Aufprall & Einrasten)")) {
                    HapticButton(title: "Heavy (Schwer)", subtitle: "Gut für harte Grenzen oder finale Aktionen", action: {
                        triggerImpact(.heavy)
                    })
                    
                    HapticButton(title: "Medium (Mittel)", subtitle: "Standard Klick-Gefühl", action: {
                        triggerImpact(.medium)
                    })
                    
                    HapticButton(title: "Light (Leicht)", subtitle: "Subtil, kaum spürbar", action: {
                        triggerImpact(.light)
                    })
                    
                    HapticButton(title: "Rigid (Starr/Hart)", subtitle: "Kurz und knackig, sehr mechanisch", action: {
                        triggerImpact(.rigid)
                    })
                    
                    HapticButton(title: "Soft (Weich)", subtitle: "Dumpfer, weicher Stoß", action: {
                        triggerImpact(.soft)
                    })
                }
                
                // MARK: - Notification Feedback
                // Simuliert System-Events
                Section(header: Text("Notification (Status)")) {
                    HapticButton(title: "Success (Erfolg)", subtitle: "Zweimaliges kurzes Summen", action: {
                        triggerNotification(.success)
                    })
                    
                    HapticButton(title: "Warning (Warnung)", subtitle: "Längeres, warnendes Vibrieren", action: {
                        triggerNotification(.warning)
                    })
                    
                    HapticButton(title: "Error (Fehler)", subtitle: "Mehrfaches, aggressives Vibrieren", action: {
                        triggerNotification(.error)
                    })
                }
                
                // MARK: - Selection Feedback
                // Simuliert das Drehen von Walzen (Picker)
                Section(header: Text("Selection (Auswahl)")) {
                    HapticButton(title: "Selection Change", subtitle: "Sehr leichtes Ticken beim Scrollen", action: {
                        triggerSelection()
                    })
                }
            }
            .navigationTitle("Haptic Lab 📳")
            .listStyle(.insetGrouped)
        }
    }
    
    // MARK: - Helper Functions
    
    func triggerImpact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare() // Reduziert Latenz
        generator.impactOccurred()
    }
    
    func triggerNotification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
    
    func triggerSelection() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
}

// Kleine Helper View für die Liste
struct HapticButton: View {
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Image(systemName: "waveform")
                    .foregroundColor(.accentColor)
            }
            .padding(.vertical, 4)
        }
    }
}

#Preview {
    HapticTest()
}
