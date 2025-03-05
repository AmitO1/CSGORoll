//
//  CookieManager.swift
//  CSGO-ROLL
//
//  Created by Amit Omer on 05/03/2025.
//

import WebKit

class CookieManager: NSObject, WKNavigationDelegate, ObservableObject {
    private var webView: WKWebView!
    static let shared = CookieManager()
    
    
    @Published var isLoggedIn: Bool = false
    
    private override init() {
        super.init()
        setupWebView()
        checkLoginStatus()
    }
    
    private func setupWebView() {
        let config = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = self
    }
    
    func loadWebsiteAndSaveCookies(){
        let url = URL(string: "https://csgoroll.com")!
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        saveCookies()
    }
    
    public func saveCookies(){
        let store = WKWebsiteDataStore.default().httpCookieStore
        store.getAllCookies{cookies in
            let cookieData = cookies.map{ cookie in
                [
                    "name" : cookie.name,
                    "value": cookie.value,
                    "domain": cookie.domain,
                    "path": cookie.path,
                    "secure": cookie.isSecure
                ]
            }
            UserDefaults.standard.set(cookieData, forKey: "savedCookies")
            print(cookieData)
            print("Cookies saved from CookieManger")
            
            DispatchQueue.main.async{
                self.checkLoginStatus()
            }
        }
    }
    
    func checkLoginStatus() {
        guard let cookieData = UserDefaults.standard.array(forKey: "savedCookies") as? [[String: Any]] else {
            DispatchQueue.main.async{
                self.isLoggedIn = false
            }
            return
        }
        for cookie in cookieData{
            if let name = cookie["name"] as? String, let value = cookie["value"] as? String{
                if name == "session" || name == "steamLoginSecure", !value.isEmpty{
                    DispatchQueue.main.async{
                        self.isLoggedIn = true
                    }
                    return
                }
            }
        }
        DispatchQueue.main.async{
            self.isLoggedIn = false
        }
        return

    }
    
    /*
     used for testing
     */
    func clearCookies() {
        let store = WKWebsiteDataStore.default().httpCookieStore
        store.getAllCookies { cookies in
            for cookie in cookies {
                store.delete(cookie)
            }
            UserDefaults.standard.removeObject(forKey: "savedCookies")
            DispatchQueue.main.async {
                self.isLoggedIn = false
            }
        }
    }

    
}
