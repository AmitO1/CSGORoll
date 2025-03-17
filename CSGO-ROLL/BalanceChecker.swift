//
//  BlanaceChecker.swift
//  CSGO-ROLL
//
//  Created by Amit Omer on 06/03/2025.
//

import Foundation
import WebKit
import SwiftUI

class BalanceChecker: NSObject, WKNavigationDelegate {
    static let shared = BalanceChecker()
    var webView: WKWebView!
    
    func DepositWinnings(completion: @escaping (Double?) -> Void) {
        
        if webView == nil {
            let webviewConfiguration = WKWebViewConfiguration()
            webView = WKWebView(frame: .zero, configuration: webviewConfiguration)
            webView.isHidden = true
        }
        
        let url = URL(string: "https://www.csgoroll.com")!
        let request = URLRequest(url: url)
        webView.load(request)
        
        webView.navigationDelegate = self
        
        // Execute first JavaScript command after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let initialJsCommands = """
                document.querySelectorAll('a.mat-button')[1].click();
                document.querySelectorAll('a.nav-link')[13].click();
            """
            self.webView.evaluateJavaScript(initialJsCommands) { result, error in
                if let error = error {
                    print("Error executing initial JavaScript: \(error)")
                    completion(nil)
                    return
                }
                print("Initial commands executed successfully.")
                
                // Execute second JavaScript command after another delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    // double timeout?? im not sure the javascript timeout even works
                    let secondJsCommands = """
                        document.querySelector('button[data-test="max"]')?.click();
                        let depositAmount = document.querySelector('input[data-test="bet-amount-input-fields"]').value;
                        document.querySelector('button[data-cy="btn-deposit-withdraw"]').click();
                        
                        // Store depositAmount in window object to make it globally accessible
                        window.depositAmount = depositAmount;
                    """

                    self.webView.evaluateJavaScript(secondJsCommands) { result, error in
                        if let error = error {
                            print("Error executing deposit commands: \(error)")
                            completion(nil)
                            return
                        }
                        
                        print("Deposit commands executed successfully.")
                        
                        self.webView.evaluateJavaScript("window.depositAmount") { result, error in
                            if let error = error {
                                print("Error retrieving deposit amount: \(error)")
                                completion(nil)
                                return
                            }
                            
                            print("Deposit amount retrieved successfully.")
                            
                            if let depositAmount = result as? String, let depositValue = Double(depositAmount){
                                
                                print("Deposit Amount :\(depositValue)")
                                
                                let defaults = UserDefaults.standard
                                if let storedAmount = defaults.value(forKey: "totalDepositAmount") as? Double{
                                    let newTotal = storedAmount + depositValue
                                    defaults.set(newTotal, forKey: "totalDepositAmount")
                                    print("Updated total deposit to: \(newTotal)")
                                    completion(newTotal)
                                }
                                else{
                                    defaults.set(depositValue, forKey: "totalDepositAmount")
                                    completion(depositValue)
                                }
                            }
                            else{
                                print("result is not a vaild number!")
                                completion(nil)
                            }
                        }
                        
                    }
                }
            }
        }
    }
    //NOTHING IMPLEMENTED YET
    func openBoxes() {
        
        if webView == nil {
            let webviewConfiguration = WKWebViewConfiguration()
            webView = WKWebView(frame: .zero, configuration: webviewConfiguration)
            webView.isHidden = true
        }
        
        let url = URL(string: "https://www.csgoroll.com")!
        let request = URLRequest(url: url)
        webView.load(request)
        
        webView.navigationDelegate = self
    }
    //DOESNT WORK YET
    func checkTimeLeft(completion: @escaping (String?) -> Void) {
        if webView == nil {
            let webviewConfiguration = WKWebViewConfiguration()
            webView = WKWebView(frame: .zero, configuration: webviewConfiguration)
            webView.isHidden = false
        }

        let url = URL(string: "https://www.csgoroll.com/boxes/view/world/level-2")!
        let request = URLRequest(url: url)
        webView.load(request)
        
        webView.navigationDelegate = self
        
        // Give some time for the page to load
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            // JavaScript to fetch the countdown and store it in window.countdownValue
            let jsCode = """
                    let countdownElement = document.querySelector('cw-countdown span');
                    let countdownText = countdownElement.textContent.trim();

                    let countdownValue = countdownText;
                    window.countdownValue = countdownValue;
                    
            """
            
            self.webView.evaluateJavaScript(jsCode) { result, error in
                if let error = error {
                    print("JavaScript error: \(error.localizedDescription)")
                } else {
                    print("Countdown stored in window.countdownValue")
                    completion(nil)
                }
                
                self.webView.evaluateJavaScript("window.countdownValue"){ result, error in
                    if let error = error {
                        print("error retreiving window countdown: \(error)")
                        completion(nil)
                    }
                    if let countdownValue = result as? String {
                        print("Countdown: \(countdownValue)")
                        completion(countdownValue)
                    }
                    else{
                        print("unkown countdown")
                        completion(nil)
                    }
                }
            }
        }
        
    }

}
/*
 to open daily boxes:
 document.querySelectorAll('a.mat-button')[1].click();
 document.querySelectorAll('a.nav-link')[10].click();
 
 or just use this link:
 https://www.csgoroll.com/boxes/world/daily-free
 
 to click create battle:
 document.querySelector('button[mat-flat-button] span[inlinesvg="assets/icons/pvp.svg"]').click();
 
 click to choose which battle type 2v2 1v1 4v4:
 document.querySelector('#mat-select-2').click();
 
 to choose 2v2:
 document.getElementById('mat-option-7')?.click();
 
 to start the battle:
 document.querySelector('[data-test="btn-unboxing-create-duel"]').click();
 */

/*
 To check time left:
 https://www.csgoroll.com/boxes/view/world/level-2-whv8smubq5
 document.querySelector('cw-countdown').innerText;
 
 */


