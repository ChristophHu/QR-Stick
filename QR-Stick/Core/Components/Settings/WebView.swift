//
//  WebView.swift
//  ios26_test
//
//  Created by Christoph Huschenhöfer on 10.12.25.
//

import SwiftUI
import WebKit

// Simple UIViewRepresentable wrapper around WKWebView
struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // no-op; navigation handled by WKWebView
    }

    func makeCoordinator() -> Coordinator { Coordinator() }

    class Coordinator: NSObject, WKNavigationDelegate {
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            // handle errors if needed
        }
    }
}

// Example SwiftUI container showing the WebView inside a NavigationStack with a close button
struct WebViewContainer: View {
    @Environment(\.dismiss) private var dismiss
    let urlString: String

    var body: some View {
        NavigationStack {
            Group {
                if let url = URL(string: urlString) {
                    WebView(url: url)
                } else {
                    Text("Invalid URL")
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle(URL(string: urlString)?.host ?? "Web")
            .navigationBarTitleDisplayMode(.inline)
            
        }
    }
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        WebViewContainer(urlString: "https://www.apple.com")
    }
}
