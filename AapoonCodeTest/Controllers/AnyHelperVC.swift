//
//  WeatherManager.swift
//  AapoonCodeTest
//
//  Created by Apple on 16/12/21.
//  Copyright © 2021 Volive Solurions . All rights reserved.
//

import UIKit
import WebKit

class AnyHelperVC: UIViewController {

    
    @IBOutlet weak var webKitView: WKWebView!
     override func viewDidLoad() {
           super.viewDidLoad()
         webKitView.navigationDelegate = self
         webKitView.uiDelegate = self
        loadAddress()
    }
    
    //MARK:- LOAD ADDRESS
    func loadAddress( ) {
        guard let url = NSURL(string: "https://openweathermap.org/faq") else {
            return
        }
        let request = URLRequest(url: url as URL)
                webKitView.load(request)
    }

}

extension AnyHelperVC:WKNavigationDelegate{
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.LoadingStart()
         // show indicator
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // dismiss indicator
        self.LoadingStop()
        // if url is not valid {
        //    decisionHandler(.cancel)
        // }
        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // dismiss indicator
      
        self.LoadingStop()
        navigationItem.title = webView.title
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
      // show error dialog
    }
}
extension AnyHelperVC: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webKitView.load(navigationAction.request)
        }
        return nil
    }
}
