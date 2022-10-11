//
//  CustomWebView.swift
//  SwiftUI_WebViewCode
//
//  Created by 조상현 on 2022/10/11.
//

import SwiftUI
import WebKit
import Combine

struct CustomWebView: UIViewRepresentable {
    
    var url: String
    
    @EnvironmentObject var viewModel: WebViewModel
    
    var oldY: CGFloat = 0

    func makeUIView(context: Context) -> some UIView {
        guard let url = URL(string: url) else {
            return WKWebView()
        }
        
        let wkWebView = WKWebView()
        wkWebView.uiDelegate = context.coordinator
        wkWebView.navigationDelegate = context.coordinator
        wkWebView.scrollView.delegate = context.coordinator
        wkWebView.load(URLRequest(url: url))
        return wkWebView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
            
    class Coordinator: NSObject {
        
        var myWebView: CustomWebView
        
        var subscriptions = Set<AnyCancellable>()
        
        init(_ myWebView: CustomWebView) {
            self.myWebView = myWebView
        }
        
    }
    
}

extension CustomWebView.Coordinator: WKUIDelegate {
    
}

extension CustomWebView.Coordinator: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        myWebView
            .viewModel
            .changedTabTypeSubject
            .compactMap { $0 }
            .sink { [self] tabType in
                if tabType == .BACK {
                    if webView.canGoBack {
                        webView.goBack()
                    }
                }
                
                else if tabType == .FORWARD {
                    if webView.canGoForward {
                        webView.goForward()
                    }
                }
                
                else if tabType == .HOME {
                    if webView.canGoBack {
                        webView.go(to: webView.backForwardList.backList.first!)
                    } else {
                        if let url = URL(string: myWebView.url) {
                            webView.load(URLRequest(url: url))
                        }
                    }
                }
                
                else if tabType == .RELOAD {
                    webView.reload()
                }
            }
            .store(in: &subscriptions)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
}

extension CustomWebView.Coordinator: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let oldY = myWebView.oldY
        
        if (oldY > scrollView.contentOffset.y) {
            myWebView.viewModel.isScrollUp.send(true)
        } else if (oldY < scrollView.contentOffset.y) {
            myWebView.viewModel.isScrollUp.send(false)
        }
        
        myWebView.oldY = scrollView.contentOffset.y
    }
}

