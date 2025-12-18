//
//  CalendarDayView.swift
//  FreetimeRepo
//
//  Created by Ben Chytrek on 15.12.25.
//

import SwiftUI

struct CalendarDayView: View {
    var body: some View {
        //Text("Hello, World!")
         Rectangle()
            .foregroundColor(.teal)
            .frame(width: 100, height: 500)
            .cornerRadius(20)
    }
    
}

#Preview {
    CalendarDayView()
}
