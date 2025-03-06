//
//  LoggedInView.swift
//  CSGO-ROLL
//
//  Created by Amit Omer on 05/03/2025.
//

import SwiftUI

struct LoggedInView: View {
    @ObservedObject var loginChecker = LoginChecker.shared
    @State private var selectedOption = "Alone"
    
    let options = ["Alone", "Bots"]
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 8) {
                Text("Welcome Back Motherfucker!")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                
                Text("Enjoy your rewards and keep collecting!")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.top, 40)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Time until boxes:")
                        .font(.headline)
                    Spacer()
                    Text("02:15:30") // Replace with dynamic value
                        .font(.body)
                        .foregroundColor(.blue)
                }
                
                HStack {
                    Text("Total saving:")
                        .font(.headline)
                    Spacer()
                    Text("$123.45") // Replace with dynamic value
                        .font(.body)
                        .foregroundColor(.green)
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Option:")
                        .font(.headline)
                    Picker("Option", selection: $selectedOption) {
                        ForEach(options, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .padding(.horizontal, 20)
            
            Spacer()
            
            Button(action: {
                LoginChecker.shared.isLoggedIn = false
            }) {
                Text("Log Out")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(radius: 3)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
        .padding()
    }
}

#Preview {
    LoggedInView()
}
