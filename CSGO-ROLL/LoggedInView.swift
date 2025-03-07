import SwiftUI

struct LoggedInView: View {
    @ObservedObject var loginChecker = LoginChecker.shared
    @State private var totalDepositAmount: Double = 0.0
    @State private var isLoading: Bool = false
    @State private var selectedOption = "Alone"
    
    let options = ["Alone", "Bots"]
    
    var body: some View {
        NavigationView {
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
                        Text("$\(totalDepositAmount, specifier: "%.2f")")
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
                    depositAmount()
                }) {
                    Text("Deposit")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(radius: 3)
                }
                .padding(.horizontal, 20)
                .disabled(isLoading)
                
                Button(action: {
                    resetEarnings()
                }) {
                    Text("Reset Earnings")
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
            .onAppear {
                let defaults = UserDefaults.standard
                if let storedAmount = defaults.value(forKey: "totalDepositAmount") as? Double {
                    totalDepositAmount = storedAmount
                }
            }
            .navigationBarItems(leading: Button(action: {
                // Add action to go back to LoginView
                // For example, you could set isLoggedIn to false and trigger navigation
                loginChecker.isLoggedIn = false
            }) {
                Image(systemName: "arrow.backward")
                    .foregroundColor(.blue)
                    .font(.title)
            })
            .navigationBarTitle("", displayMode: .inline)
        }
    }
    
    private func depositAmount() {
        isLoading = true
        BalanceChecker.shared.DepositWinnings { newTotal in
            DispatchQueue.main.async{
                isLoading = false
                if let newTotal = newTotal {
                    totalDepositAmount = newTotal
                    
                    UserDefaults.standard.set(newTotal, forKey: "totalDepositAmount")
                }
            }
        }
    }
    
    private func resetEarnings() {
        totalDepositAmount = 0.0
        UserDefaults.standard.set(0.0, forKey: "totalDepositAmount")
    }
}

#Preview {
    LoggedInView()
}
