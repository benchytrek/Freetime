
//
//  LoginView.swift
//  FreetimeRepo
//
//  Created by Ben Chytrek on 30.01.26.
//
/*
import SwiftUI
import FirebaseAuth

struct LoginView: View {
    // MARK: - State Properties
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoggingIn: Bool = false
    @State private var errorMessage: String = ""
    
    // MARK: - Background Animation States
    // Identische Animation wie CreateAccountView für Konsistenz
    @State private var meshPoints: [SIMD2<Float>] = [
        .init(0, 0), .init(0.5, 0), .init(1, 0),
        .init(0, 0.5), .init(0.5, 0.5), .init(1, 0.5),
        .init(0, 1), .init(0.5, 1), .init(1, 1)
    ]
    
    @State private var animateGradient: Bool = false
    
    var body: some View {
        ZStack {
            // 1. Hintergrund
            Group {
                if #available(iOS 18.0, *) {
                    MeshGradient(width: 3, height: 3, points: meshPoints, colors: [
                        .black, .indigo, .black,
                        .blue, .purple, .cyan,
                        .black, .blue, .black
                    ])
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            randomizeMesh()
                        }
                    }
                } else {
                    fallbackBackground
                }
            }
            
            // 2. Vordergrund: Glas-Karte
            VStack(spacing: 25) {
                
                // Titel (Optional, aber gut für Login)
                Text("Welcome Back")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                
                // Eingabefelder
                VStack(spacing: 15) {
                    
                    // Email
                    TextField("", text: $email)
                        .placeholder(when: email.isEmpty) {
                            Text("Email").foregroundColor(.white.opacity(0.5))
                        }
                        .foregroundColor(.white)
                        .accentColor(.cyan)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                    
                    Divider()
                        .background(Color.white.opacity(0.3))
                    
                    // Passwort
                    SecureField("", text: $password)
                        .placeholder(when: password.isEmpty) {
                            Text("Password").foregroundColor(.white.opacity(0.5))
                        }
                        .foregroundColor(.white)
                        .accentColor(.cyan)
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(LinearGradient(colors: [.white.opacity(0.4), .clear], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
                )
                
                // Fehlermeldung
                if !errorMessage.isEmpty {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                        Text(errorMessage)
                    }
                    .font(.caption)
                    .foregroundColor(.red.opacity(0.9))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .transition(.opacity)
                }
                
                // Action Button (Sign In)
                Button(action: performLogin) {
                    HStack {
                        if isLoggingIn {
                            ProgressView()
                                .tint(.black)
                        } else {
                            Text("Sign In")
                                .fontWeight(.bold)
                            Image(systemName: "arrow.right")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(15)
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                }
                .disabled(isLoggingIn || email.isEmpty || password.isEmpty)
                .opacity((email.isEmpty || password.isEmpty) ? 0.6 : 1.0)
                
                // Trenner
                HStack {
                    Rectangle().frame(height: 1).opacity(0.3)
                    Text("or").font(.caption).opacity(0.5)
                    Rectangle().frame(height: 1).opacity(0.3)
                }
                .foregroundColor(.white)
                .padding(.vertical, 5)

                // Apple Sign-In
                SignInWithApple()
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
            }
            .padding(30)
            .background(.regularMaterial)
            .cornerRadius(30)
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(.white.opacity(0.6), lineWidth: 1)
            )
            .padding(.horizontal, 20)
            .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
        }
    }
    
    // MARK: - Logic
    
    private func randomizeMesh() {
        // Gleiche Animation wie CreateAccountView
        let base: [SIMD2<Float>] = [
            .init(0, 0),   .init(0.5, 0),   .init(1, 0),
            .init(0, 0.5), .init(0.5, 0.5), .init(1, 0.5),
            .init(0, 1),   .init(0.5, 1),   .init(1, 1)
        ]
        
        var newPoints = base
        let movableIndices = [1, 3, 4, 5, 7]
        
        for i in movableIndices {
            let randomX = Float.random(in: -0.2...0.2)
            let randomY = Float.random(in: -0.2...0.2)
            newPoints[i].x += randomX
            newPoints[i].y += randomY
        }
        meshPoints = newPoints
    }
    
    private func performLogin() {
        guard !email.isEmpty, !password.isEmpty else { return }
        
        isLoggingIn = true
        errorMessage = ""
        
        // Firebase Login
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            isLoggingIn = false
            
            if let error = error {
                withAnimation {
                    errorMessage = error.localizedDescription
                }
            } else {
                print("User logged in successfully: \(result?.user.uid ?? "unknown")")
                // Hier könnte eine Navigation oder State-Änderung folgen
            }
        }
    }
    
    // Fallback View
    var fallbackBackground: some View {
        GeometryReader { proxy in
            ZStack {
                Color.black.ignoresSafeArea()
                
                Circle()
                    .fill(Color.blue)
                    .blur(radius: 120)
                    .frame(width: 400, height: 400)
                    .position(x: animateGradient ? 50 : 350, y: animateGradient ? 100 : 200)
                
                Circle()
                    .fill(Color.cyan)
                    .blur(radius: 100)
                    .frame(width: 300, height: 300)
                    .position(x: animateGradient ? 350 : 50, y: animateGradient ? 700 : 500)
                
                Circle()
                    .fill(Color.purple.opacity(0.8))
                    .blur(radius: 110)
                    .frame(width: 350, height: 350)
                    .position(x: animateGradient ? 200 : 300, y: animateGradient ? 400 : 100)
            }
            .ignoresSafeArea()
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 7).repeatForever(autoreverses: true)) {
                animateGradient.toggle()
            }
        }
    }
}

#Preview {
    LoginView()
}
*/
