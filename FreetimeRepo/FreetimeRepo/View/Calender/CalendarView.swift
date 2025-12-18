//
//  CalendarView.swift
//  FreetimeRepo
//
//  Created by Ben Chytrek on 15.12.25.
//

import SwiftUI

struct CalendarView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Hello, World!")

            HStack {
                CalendarDayView()
                    //.background(Color.blendMode(.))
                    //.Transparency(0.1) soll transparent auf 10%
                    .offset(x: 30)
                    .transformEffect(CGAffineTransform(scaleX: 0.5, y: 1))
                    //.scaleEffect(1.5)
                    .offset(x: 40)
                    
                    .onTapGesture {TapGesture().onEnded { _ in print("liste nach links") }}
                    Text("testlooooooolo")

                CalendarDayView()
                CalendarDayView()
                CalendarDayView()
                CalendarDayView()
                    //.transparent soll werden 0.8
                    // .frame(maxWidth: 20, maxhHeight: 10)
                    .background(Color.red)
                    .offset(x: 30)
                    .transformEffect(CGAffineTransform(scaleX: 0.5, y: 0.5))
                    .offset(x: -10, y: 100)
                
                    .onTapGesture {TapGesture().onEnded { _ in print("liste nach rechts") }}
            }
            //.offset(x: 50)
        }
    }
}

#Preview {
    CalendarView()
}
