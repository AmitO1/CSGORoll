//
//  BlanaceChecker.swift
//  CSGO-ROLL
//
//  Created by Amit Omer on 06/03/2025.
//

import Foundation
import WebKit
import SwiftUI

class BalanceChecker: NSObject {
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
}

extension BalanceChecker: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("WebView Finished loading")
    }
}
