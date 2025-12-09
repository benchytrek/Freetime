//
//  InviteView.swift
//  FreetimeRepo
//
//  Created by Ben Chytrek on 09.12.25.
//

import SwiftUI

struct InviteView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Person1")
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                Text("Person2")
                    .padding()
                    .background(Color.yellow)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                Text("Person3")
                    .padding()
                    .background(Color.pink)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                
            }
            Spacer()
            Text("Hello, World!")
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
                .shadow(radius: 5)
            Text("Hello, World!")
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
                .shadow(radius: 5)
            
        }
    }
}

#Preview {
    InviteView()
}
