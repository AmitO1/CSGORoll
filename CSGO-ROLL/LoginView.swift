//
//  LoginView.swift
//  CSGO-ROLL
//
//  Created by Amit Omer on 05/03/2025.
//

import SwiftUI

struct LoginView: View {
    @State private var showWebView = false
    @State private var isLoggedIn = LoginChecker.shared.isLoggedIn
    @ObservedObject var loginChecker = LoginChecker.shared
    
    var body: some View {
        VStack {
            if isLoggedIn {
                // If logged in, show the logged-in view
                LoggedInView()
            } else {
                // If not logged in, show the WebView button
                Text("CSGORoll Auto Login")
                    .font(.title)
                    .padding()
                
                Button(action: {
                    // Check login status after button click
                    if loginChecker.isLoggedIn {
                        isLoggedIn = true
                    } else {
                        showWebView = true
                    }
                }) {
                    Text("Login to CSGORoll")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                .sheet(isPresented: $showWebView, onDismiss: {
                    LoginChecker.shared.checkLoginStatus()
                }) {
                    WebView(url: URL(string: "https://www.csgoroll.com")!)
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
