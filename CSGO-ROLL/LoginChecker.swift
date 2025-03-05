//
//  LoginChecker.swift
//  CSGO-ROLL
//
//  Created by Amit Omer on 05/03/2025.
//


import WebKit

class LoginChecker: NSObject, WKNavigationDelegate, ObservableObject {
    
    private var webView: WKWebView!
    static let shared = LoginChecker()
    
    @Published var isLoggedIn: Bool = false
    
    private override init() {
        super.init()
        setupWebView()
    }

    // Setting up the WKWebView for background operation
    private func setupWebView() {
        let config = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = self
        webView.isHidden = true // Make sure the WebView is not visible
    }

    // Start loading the website in the background to check login status
    func checkLoginStatus() {
        let url = URL(string: "https://csgoroll.com")!
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    // This delegate method is called when the page finishes loading
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        checkForLoginButton()
    }

    // Function to search for the login button in the page HTML
    private func checkForLoginButton() {
        // Add a delay to ensure the page has fully loaded
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {  // Adjust delay if needed
            self.webView.evaluateJavaScript("document.body.innerHTML") { (result, error) in
                if let htmlContent = result as? String {
                    // Check if the login button is present in the HTML content
                    self.isLoggedIn = !htmlContent.contains("data-test=\"auth-login-btn\"")
                    print(self.isLoggedIn)
                    print(self.isLoggedIn ? "User is logged in" : "User is logged out")
                } else {
                    print("Error retrieving HTML content")
                    self.isLoggedIn = false
                }
            }
        }
    }
    
    /*
     first two can be used to access the daily boxes
     document.querySelectorAll('a.mat-button')[1].click();
     document.querySelectorAll('a.nav-link')[10].click();
     */

}
