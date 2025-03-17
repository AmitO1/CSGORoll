//
//  BackgroundTaskManager.swift
//  CSGO-ROLL
//
//  Created by Amit Omer on 17/03/2025.
//

import Foundation
import BackgroundTasks
import UserNotifications

class BackgroundTaskManager {

    static let shared = BackgroundTaskManager()

    private init() {}
    
    func registerBackgroundTask() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.yourapp.checkCountdown", using: nil) { task in
            self.handleBackgroundTask(task: task)
        }
    }

    func scheduleBackgroundTask() {
        print("test to see if scheduling works!")
        let request = BGAppRefreshTaskRequest(identifier: "com.yourapp.checkCountdown")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 3600)
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Failed to schedule background task: \(error)")
        }
    }

    func handleBackgroundTask(task: BGTask) {
        // Perform the countdown check
        HiddenWebView.shared.checkTimeLeft { value in
            if let countdown = value, countdown == "00:00:00" {
                // Run your script here
                print("Countdown reached zero, running script...")
            }
        }

        // Mark the task as completed
        task.setTaskCompleted(success: true)
        
        // Reschedule the task after it finishes
        scheduleBackgroundTask()
    }
}
