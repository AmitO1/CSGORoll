//
//  LoggedInView.swift
//  CSGO-ROLL
//
//  Created by Amit Omer on 05/03/2025.
//

import SwiftUI

struct LoggedInView: View {
    @ObservedObject var loginChecker = LoginChecker.shared
    var body: some View {
        VStack {
            Text("Welcome, Motherfucker i didnt have power to put your name in")
                .font(.title)
                .padding()
            
            Button(action: {
                LoginChecker.shared.isLoggedIn = false
            }) {
                Text("Log Out")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
    }
}

#Preview {
    LoggedInView()
}
