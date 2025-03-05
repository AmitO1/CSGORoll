//
//  ContentView.swift
//  CSGO-ROLL
//
//  Created by Amit Omer on 05/03/2025.
//

import SwiftUI


struct ContentView: View {
    @ObservedObject var loginChecker = LoginChecker.shared
    
    var body: some View {
        VStack{
            if loginChecker.isLoggedIn{
                LoggedInView()
            }
            else{
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
}
