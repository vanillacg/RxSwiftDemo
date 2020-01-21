//
//  CGDetailVC.swift
//  CGMK
//
//  Created by chenguang on 2019/12/26.
//  Copyright © 2019 chenguang. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class CGDetailVC: UIViewController, WKNavigationDelegate {
    var webView: WKWebView = {
        let config = WKWebViewConfiguration.init()
        config.preferences.minimumFontSize = 9.0;
        let webView = WKWebView.init(frame: CGRect(x: 0.0, y: 0.0, width: CGScreenWidth, height: CGScreenHeight), configuration:config)
        return webView
    }()
    
    var itemData: NewsContentItem?
    
    public init(item: NewsContentItem?) {
        super.init(nibName: nil, bundle: nil)
        itemData = item
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "详情页"
        view.addSubview(webView)
        webView.navigationDelegate = self
        
//        if !(itemData?.article_url.isEmpty ?? true) {
//            let request =  URLRequest(url: URL(string: itemData?.article_url ??)!)
//            webView.load(request)
//        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("didFinish")
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("didFail")
    }
}
