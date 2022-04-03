//
//  WebViewController.swift
//  Players_Core_Data
//
//  Created by Kate Murray on 03/04/2022.
//

import UIKit
import WebKit

/*
 [1] Code based on: Youtube Tutorial "Create WebView in App (Swift 5, Xcode 12, 2022) - iOS Development", iOS Academy,
https://www.youtube.com/watch?v=JafGypqFvs4
*/
class WebViewController: UIViewController {
    var p: Player!
    let webView : WKWebView = {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = prefs
        let webView = WKWebView(frame: .zero, configuration: configuration)
        return webView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        let tabBar = tabBarController as! PlayerTabController
        p = tabBar.p
        view.addSubview(webView)
        guard let url = URL(string: p.url!) else{
            return
        }
        webView.load(URLRequest(url: url))
        DispatchQueue.main.asyncAfter(deadline: .now()+5){
            self.webView.evaluateJavaScript("document.body.innerHTML"){result, error in
                guard let html  = result as? String, error == nil else{
                    return
                }
                print(html)
            }
        }
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame.size.height = view.frame.height * 95/100
        webView.frame.size.width = view.frame.width
    }
    
// [1] END
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
