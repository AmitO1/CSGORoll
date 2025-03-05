//
//  WebView.swift
//  CSGO-ROLL
//
//  Created by Amit Omer on 05/03/2025.
//


import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate  = context.coordinator
        let request = URLRequest(url: url)
        webView.load(request)
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
           return Coordinator(parent: self)
       }

       class Coordinator: NSObject, WKNavigationDelegate {
           var parent: WebView

           init(parent: WebView) {
               self.parent = parent
           }

       }
    
}

