//
//  WebView.swift
//  TiogaFolios
//
//  Created by Kristofer Younger on 1/2/23.
//

import SwiftUI
import WebKit
 
struct WebView: UIViewRepresentable {
 
    var url: URL
 
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
 
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
