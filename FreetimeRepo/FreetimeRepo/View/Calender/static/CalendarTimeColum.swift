//
//  CalendarTimeColum.swift
//  FreetimeRepo
//
//  Created by Ben Chytrek on 15.12.25.
//

import SwiftUI

struct CalendarTimeColum: View {
    // Layout Konfiguration
    let startHour: Int = 8
    let endHour: Int = 22
    let hourHeight: CGFloat = 30 // WICHTIG: Muss überall gleich sein!
    
    var body: some View {
        VStack(spacing: 0) {
            // Wir loopen von 8 bis 22 in 2er Schritten (stride)
            ForEach(Array(stride(from: startHour, through: endHour, by: 2)), id: \.self) { hour in
                
                // Ein Zeit-Block
                Text("\(hour)")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
                    .frame(height: hourHeight * 2, alignment: .top) // *2 weil wir 2h Schritte machen
                    .frame(maxWidth: .infinity, alignment: .leading)
                    //.padding(.trailing, 8)
                    // Kleiner Strich nach oben verschoben, damit er mittig zur Grid-Line sitzt
                    .offset(y: hourHeight / 2)
            }
        }
        .frame(width: 30) // Feste Breite für die linke Spalte
        //.padding(.top, 10) // Kleines Padding zum Start
        .border(Color.gray.opacity(0.2), width: 0.5)
    }
}

#Preview {
    CalendarTimeColum()
        .border(.gray)
        .background(
            LinearGradient(
                colors: [Color(.orange), Color(.teal).opacity(20)],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        
}
