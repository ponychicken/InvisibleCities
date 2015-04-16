//
//  WebViewController.swift
//  InvisibleCities
//
//  Generic WebViewController
//

import WebKit
import AVFoundation
import Foundation

class WebViewController: UIViewController, UINavigationBarDelegate, WKNavigationDelegate {
    
    var webView: WKWebView?
    var curReq: NSURLRequest?
    var url = startURL
    
    override func loadView() {
        super.loadView()
        
        var config = WKWebViewConfiguration()
        config.mediaPlaybackAllowsAirPlay = false;
        config.mediaPlaybackRequiresUserAction = false;
        config.allowsInlineMediaPlayback = true;
        
        self.webView = WKWebView(
            frame: self.view.bounds,
            configuration: config
        )
        
        self.webView?.navigationDelegate = self
        self.webView?.scrollView.bounces = false
        self.webView?.description
        
        self.view = self.webView
        
        self.setUrlFromString(self.url)
        
        if (curReq != nil) {
            self.webView!.loadRequest(curReq!)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var cacheSizeMemory = 8*1024*1024; // 8MB
        var cacheSizeDisk = 32*1024*1024; // 32MB
        
        var sharedCache = NSURLCache.init(
            memoryCapacity:cacheSizeMemory,
            diskCapacity:cacheSizeDisk,
            diskPath: "nsurlcache"
        )
        
        NSURLCache.setSharedURLCache(sharedCache)
    }
    
    override func didReceiveMemoryWarning() {
        println("Received memory warning")
        
        NSURLCache.sharedURLCache().removeAllCachedResponses()
        
        super.didReceiveMemoryWarning()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func setUrlFromString(urlstring: String) {
        self.url = urlstring;
        let url = NSURL(string: urlstring)
        curReq = NSURLRequest(URL: url!)
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        // Disable selection
        webView.evaluateJavaScript("document.documentElement.style.webkitUserSelect='none';", completionHandler: nil);
        webView.evaluateJavaScript("document.documentElement.style.webkitTouchCallout='none';", completionHandler: nil);
    }
}
