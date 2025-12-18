//
//  CalendarView.swift
//  FreetimeRepo
//
//  Refactored by Senior Dev Partner on 18.12.25.
//

import SwiftUI

struct CalendarView: View {
    // Zugriff auf die Daten
    @State private var viewModel = CalendarViewModel()
    
    // NEU: Wir merken uns, welcher Tag gerade in der Mitte (fokussiert) ist
    @State private var currentDayID: UUID?
    
    var body: some View {
        //Zstack neu für Calendar time column. an der linken seite
        ZStack {// warum ist das ein ZStack?
            VStack(alignment: .leading, spacing: 16) {
                Text("Calendar")
                    .font(Font.largeTitle.bold())
                    .padding()
                    .cornerRadius(8)
                    .padding()
                    .shadow(color: Color.black.opacity(0.3), radius: 16, x: 20, y: 10)
                
                //Calendar Date Row soll über den CalendarDayView mit den gleichen datum wie die CalendarDayView sein 
                
                // 1. DER SCROLLVIEW READER
                ScrollViewReader { scrollProxy in
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 0) {
                            
                            ForEach(viewModel.days) { day in
                                CalendarDayView(day: day)
                                    .frame(width: 100)
                                    .padding(6)
                                    .id(day.id) // Adresse für den Reader & scrollPosition
                                
                                // Deine Layout-Animationen
                                    .scrollTransition(.interactive, axis: .horizontal) { view, position in
                                        view
                                            .opacity(position.value < -0.3 ? 0.3 : 1.0)
                                            .scaleEffect(position.value < -0.3 ? 0.8 : 1.0)
                                            .scaleEffect(position.value > 0.3 ? 0.5 : (position.value < -0.3 ? 0.8 : 1.0))
                                            .offset(x: position.value > 0.3 ? -30 : 0)
                                    }
                                // 3. ON TAP LOGIK (Verbessert)
                                    .onTapGesture {
                                        // LOGIK: Wenn dieser Tag bereits in der Mitte ist, ignorieren wir den Klick.
                                        // Das verhindert, dass man auf den mittleren Tag tippt und "nichts" passiert oder es zuckt.
                                        guard day.id != currentDayID else { return }
                                        
                                        withAnimation(.snappy) {
                                            // Scrollt den angetippten Tag (links oder rechts) in die Mitte
                                            scrollProxy.scrollTo(day.id, anchor: .center)
                                            // Update state (passiert durch scrollPosition meist automatisch, aber hier erzwingen wir den Fokus visuell)
                                            currentDayID = day.id
                                        }
                                        print("Navigated to day: \(day.dayNumber)")
                                    }
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .scrollTargetBehavior(.viewAligned)
                    // NEU: Bindet die Scroll-Position an unsere Variable
                    .scrollPosition(id: $currentDayID)
                    .contentMargins(.horizontal, 40, for: .scrollContent)
                    .frame(height: 500)
                }
            }
            .onAppear {
                if viewModel.days.isEmpty { viewModel.loadData() }
            }
            // NEU: Initialisieren, damit wir nicht bei nil starten
            .onChange(of: viewModel.days) { _, newDays in
                if currentDayID == nil, let firstToday = newDays.first(where: { $0.isToday }) {
                    currentDayID = firstToday.id
                } else if currentDayID == nil {
                    currentDayID = newDays.first?.id
                }
            }
        }
    }
}

#Preview {
    CalendarView()
}
