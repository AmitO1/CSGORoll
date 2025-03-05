//
//  CSGO_ROLLApp.swift
//  CSGO-ROLL
//
//  Created by Amit Omer on 05/03/2025.
//

import SwiftUI
import SwiftData


@main
struct CSGO_ROLLApp: App {
    @Environment(\.scenePhase) private var scenePhase
    
    init(){
        LoginChecker.shared.checkLoginStatus()
    }
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .onChange(of: scenePhase) {oldValue, phase in
            if phase == .background {
                print("checking if logged in")
                LoginChecker.shared.checkLoginStatus()
                //currently not in use
            }
        }
        
    }
}
