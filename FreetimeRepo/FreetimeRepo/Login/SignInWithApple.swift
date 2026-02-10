
//
//  SignInWithApple.swift
//  FreetimeRepo
//
//  Created by Ben Chytrek on 30.01.26.
//

import SwiftUI
import AuthenticationServices
import FirebaseAuth
import CryptoKit

struct SignInWithApple: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var currentNonce: String?

    var body: some View {
        SignInWithAppleButton(
            onRequest: { request in
                // 1. Nonce vorbereiten
                let nonce = randomNonceString()
                currentNonce = nonce
                request.requestedScopes = [.fullName, .email]
                request.nonce = sha256(nonce)
            },
            onCompletion: { result in
                switch result {
                case .success(let authResults):
                    // 2. Login erfolgreich, Firebase authentifizieren
                    handleAuthorization(authResults)
                case .failure(let error):
                    print("Authorisation failed: \(error.localizedDescription)")
                }
            }
        )
        .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
        .frame(height: 50)
        .cornerRadius(15)
    }

    // MARK: - Firebase Auth Handler
    private func handleAuthorization(_ authResults: ASAuthorization) {
        switch authResults.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }

            let credential = OAuthProvider.credential(providerID: .apple,
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)

            // 3. Mit Firebase anmelden
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    print("Firebase Sign In Error: \(error.localizedDescription)")
                    return
                }
                // User is signed in
                print("User logged in with Apple: \(authResult?.user.uid ?? "unknown")")
            }
        default:
            break
        }
    }

    // MARK: - Crypto Helpers (Required for Firebase)
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
        }
        let charset: [Character] =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        let nonce = randomBytes.map { byte in
            charset[Int(byte) % charset.count]
        }
        return String(nonce)
    }

    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        return hashedData.compactMap { String(format: "%02x", $0) }.joined()
    }
}
