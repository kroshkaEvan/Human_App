//
//  AppWebView.swift
//  AV
//
//  Created by IvanDev on 29/07/2024.
//

import SwiftUI
import WebKit

class WebViewScriptMessageHandler: NSObject, WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "scrollListener", let messageBody = message.body as? String, messageBody == "bottom" {
            log("Reached bottom of the list")
        }
    }
}

struct AppWebView: UIViewRepresentable {
    let webView: WKWebView = WKWebView()
    private let messageHandler = WebViewScriptMessageHandler()

    init() {
        let jsScroll = """
            window.addEventListener('scroll', function() {
                if ((window.innerHeight + window.scrollY) >= document.body.offsetHeight) {
                    window.webkit.messageHandlers.scrollListener.postMessage('bottom');
                }
            });
        """
        let userScript = WKUserScript(source: jsScroll,
                                      injectionTime: .atDocumentEnd,
                                      forMainFrameOnly: true)
        webView.configuration.userContentController.addUserScript(userScript)
        webView.configuration.userContentController.add(self.messageHandler, name: "scrollListener")
    }

    func makeUIView(context: Context) -> WKWebView {
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }
    
    func loadURL(urlString: String) {
        if let urlDocs = Bundle.main.url(forResource: urlString,
                                         withExtension: "pdf") {
            webView.load(URLRequest(url: urlDocs))
        } else {
            log("Invalid URL webView")
        }
    }
}
