//
//  LoginView.swift
//  CSGO-ROLL
//
//  Created by Amit Omer on 05/03/2025.
//

import SwiftUI

struct LoginView: View {
    @State private var showWebView = false
    @ObservedObject var loginChecker = LoginChecker.shared
    
    var body: some View{
        VStack {
            Text("CSGORoll Auto Login")
                .font(.title)
                .padding()
            
            Button(action: {
                showWebView = true
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
        }
        .sheet(isPresented: $showWebView, onDismiss: {
            LoginChecker.shared.checkLoginStatus()
        }){
            WebView(url: URL(string : "https://www.csgoroll.com")!)
        }
    }
}

#Preview {
    LoginView()
}
