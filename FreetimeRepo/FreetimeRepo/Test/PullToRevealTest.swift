//
//  PullToRevealTest.swift
//  FreetimeRepo
//
//  Created by Ben Chytrek on 12.01.26.
//

import SwiftUI

struct PullToRevealTest: View {
    
    // --- STATE ---
    @State private var scrollPosition: Int? = 1
    @State private var isSearchActive: Bool = false
    @State private var pullProgress: CGFloat = 0.0
    
    // --- CONFIG ---
    let triggerHeight: CGFloat = 100
    
    // --- COMPUTED PROPS (Hilft dem Compiler!) ---
    private var iconColor: Color {
        pullProgress > 0.8 ? .blue : .gray
    }
    
    private var iconScale: CGFloat {
        pullProgress > 0.8 ? 1.2 : 1.0
    }
    
    // --- BODY ---
    var body: some View {
        ScrollView {
            mainContent
        }
        .coordinateSpace(name: "scrollSpace")
        .scrollPosition(id: $scrollPosition)
        .onPreferenceChange(ScrollOffsetKey.self) { value in
            handleScrollOffset(value)
        }
        .onAppear {
            scrollPosition = 1
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.75), value: scrollPosition)
    }
    
    // --- SUB-VIEWS ---
    
    @ViewBuilder
    private var mainContent: some View {
        VStack(spacing: 0) {
            headerSection
            scrollSensor
            listSection
        }
    }
    
    private var headerSection: some View {
        ZStack {
            Color.gray.opacity(0.1)
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .font(.title2)
                    .foregroundStyle(iconColor) // Variable statt Logik
                    .scaleEffect(iconScale)     // Variable statt Logik
                    .animation(.snappy, value: pullProgress > 0.8)
                
                Text("Quick Find")
                    .font(.headline)
                    .opacity(Double(pullProgress))
            }
            .offset(y: 10)
        }
        .frame(height: triggerHeight)
        .id(0)
    }
    
    private var scrollSensor: some View {
        GeometryReader { proxy in
            let minY = proxy.frame(in: .named("scrollSpace")).minY
            Color.clear
                .preference(key: ScrollOffsetKey.self, value: minY)
        }
        .frame(height: 0)
    }
    
    private var listSection: some View {
        VStack(spacing: 16) {
            ForEach(0..<15) { i in
                taskRow(index: i)
            }
        }
        .padding()
        .id(1)
        .background(Color.gray.opacity(0.05))
    }
    
    // Kleine Helper-View für die Rows
    private func taskRow(index: Int) -> some View {
        HStack {
            Circle()
                .frame(width: 40, height: 40)
                .foregroundStyle(.blue.opacity(0.2))
            
            VStack(alignment: .leading) {
                Text("Task \(index + 1)")
                    .fontWeight(.bold)
                Rectangle()
                    .frame(height: 8)
                    .frame(width: 100) // .width gibt es so nicht, muss .frame sein
                    .foregroundStyle(.gray.opacity(0.1))
            }
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
    
    // --- LOGIC ---
    
    private func handleScrollOffset(_ minY: CGFloat) {
        let progress = max(0, min(minY / triggerHeight, 1.0))
        self.pullProgress = progress
        
        if minY > triggerHeight && !isSearchActive {
            triggerSearch()
        }
        
        if isSearchActive && minY < -40 {
            isSearchActive = false
        }
    }
    
    private func triggerSearch() {
        isSearchActive = true
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        
        withAnimation {
            scrollPosition = 0
        }
    }
}

// --- PREFERENCE KEY ---
struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
    PullToRevealTest()
}
