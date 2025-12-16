//
//  DateHeaderView.swift
//  FreetimeRepo
//
//  Created by Ben Chytrek on 15.12.25.
//

import SwiftUI

struct CalendarDateRow: View {
    
    var body: some View {
        
        HStack(spacing: 70) {
            VStack(alignment: .center, spacing: 10) {
                Text("Mon")
                Text("1")
            }
            VStack(alignment: .leading, spacing: 3) {
                Text("Din")
                Text("2")
            }
            VStack(alignment: .leading, spacing: 3) {
                Text("Mit")
                Text("3")
            }

        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGroupedBackground))
        
        HStack(spacing: 10) {
            ForEach(1...30, id: \.self) { day in
                VStack(alignment: .center, spacing: 10) {
                    Text("\(day)")
                }
            }
            
            Text("1")
            Text("2")
            Text("3")
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGroupedBackground))
    }
}

#Preview {

        CalendarDateRow()

    .padding()
    .background(Color(.systemGroupedBackground))
}
