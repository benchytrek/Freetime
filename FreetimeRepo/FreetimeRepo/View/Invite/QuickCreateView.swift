
//
//  QuickCreateView.swift
//  FreetimeRepo
//
//  Created by Freetime Dev on 24.01.26.
//

import SwiftUI

struct QuickCreateView: View {
    // Environment für das Schließen des Sheets
    @Environment(\.dismiss) var dismiss
    
    // Einfache States für den MVP
    @State private var title: String = ""
    @State private var date: Date = Date()
    @State private var notes: String = ""
    
    // Fokus-Management für die Tastatur
    @FocusState private var isTitleFocused: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 1. Hintergrund: Leichtes Grau für Kontrast zum "Liquid" Material
                Color(uiColor: .systemGroupedBackground)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        
                        // MARK: - Input Section (Liquid Style)
                        VStack(spacing: 0) {
                            // Titel Eingabe
                            TextField("Titel (z.B. Gym Session)", text: $title)
                                .font(.title3.weight(.medium))
                                .padding()
                                .focused($isTitleFocused)
                                .submitLabel(.next)
                            
                            Divider()
                                .padding(.leading)
                            
                            // Notiz Eingabe
                            TextField("Notizen oder Ort hinzufügen...", text: $notes, axis: .vertical)
                                .font(.body)
                                .padding()
                                .frame(minHeight: 80, alignment: .top)
                        }
                        .background(.ultraThinMaterial) // Das "Liquid Glass"
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
                        
                        // MARK: - Date Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("ZEITPUNKT")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .padding(.leading, 4)
                            
                            DatePicker("Datum wählen", selection: $date)
                                .datePickerStyle(.graphical)
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
                        }
                        
                        // Spacer für Scrolling auf kleinen Phones
                        Color.clear.frame(height: 100)
                    }
                    .padding()
                }
                
                // MARK: - Floating Action Button (Unten fixiert)
                VStack {
                    Spacer()
                    Button(action: createInvite) {
                        Text("Invite erstellen")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(title.isEmpty ? Color.gray.opacity(0.5) : Color.accentColor)
                            )
                            .shadow(color: title.isEmpty ? .clear : Color.accentColor.opacity(0.3), radius: 10, y: 5)
                    }
                    .disabled(title.isEmpty)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                }
            }
            .navigationTitle("Neues Event")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                // Tastatur öffnet sich automatisch für schnelle Eingabe
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isTitleFocused = true
                }
            }
        }
    }
    
    // MARK: - Actions
    func createInvite() {
        // Hier später: ViewModel.add(...) aufrufen
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        dismiss()
    }
}

#Preview {
    QuickCreateView()
}
