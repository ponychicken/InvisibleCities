//
//  WebViewController.swift
//  InvisibleCities
//
//  Generic WebViewController
//

import WebKit
import AVFoundation
import Foundation


#if DEBUG
    let server = "http://pony.local:8000/"
    let suffix = "navigation/index.html"
    #else
let server = "http://localhost:8116/"
let suffix = "navigation/index.html"
#endif

class WebViewController: UIViewController, UINavigationBarDelegate, WKNavigationDelegate {
    
    var webView: WKWebView?
    var curReq: NSURLRequest?
    var loadingImageView: UIImageView?
    var url = suffix
    
    override func loadView() {
        super.loadView()
        
        let config = WKWebViewConfiguration()
        
        if #available(iOS 9.0, *) {
            config.requiresUserActionForMediaPlayback = false
            config.allowsAirPlayForMediaPlayback = false
        } else {
            config.mediaPlaybackRequiresUserAction = false
            config.mediaPlaybackAllowsAirPlay = false
        }
        
        config.allowsInlineMediaPlayback = true;
        
        self.webView = WKWebView(
            frame: self.view.bounds,
            configuration: config
        )
        
        self.webView?.navigationDelegate = self
        self.webView?.scrollView.bounces = false
        self.webView?.description
        
        self.view = self.webView
        
        
        #if DEBUG
            self.createReqFromUrl(self.url)
            if (curReq != nil) {
            self.webView!.loadRequest(curReq!)
            }
            #else
            if #available(iOS 9.0, *) {
                if let root = NSBundle.mainBundle().resourceURL?.URLByAppendingPathComponent("Cities") {
                    print(root)
                    //var error: NSError?
                    let url = root.URLByAppendingPathComponent(self.url)
                    print(url)
                    self.webView!.loadFileURL(url, allowingReadAccessToURL: root)
                }
            } else {
                self.createReqFromUrl(self.url)
                if (curReq != nil) {
                    self.webView!.loadRequest(curReq!)
                }
            }
        #endif
        
    }
    
    
    override func viewDidLoad() {
        
        // Show launch image while loading the very first view
        if (url == "navigation/index.html") {
            loadingImageView = UIImageView(frame: (webView?.frame)!)
            self.view.addSubview(loadingImageView!)
            
            if let img = splashImageForOrientation(UIApplication.sharedApplication().statusBarOrientation, size: self.view.bounds.size) {
                loadingImageView?.image = UIImage(named: img)
            }
            
            self.view.addSubview(loadingImageView!)
        }

        super.viewDidLoad()
        
        let cacheSizeMemory = 8*1024*1024; // 8MB
        let cacheSizeDisk = 32*1024*1024; // 32MB
        
        let sharedCache = NSURLCache.init(
            memoryCapacity:cacheSizeMemory,
            diskCapacity:cacheSizeDisk,
            diskPath: "nsurlcache"
        )
        
        NSURLCache.setSharedURLCache(sharedCache)
    }
    
    override func didReceiveMemoryWarning() {
        print("Received memory warning")
        
        NSURLCache.sharedURLCache().removeAllCachedResponses()
        
        super.didReceiveMemoryWarning()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func createReqFromUrl(urlstring: String) {
        self.url = urlstring;
        
        let url = NSURL(string: server + urlstring)
        curReq = NSURLRequest(URL: url!)
    }
    
    // MARK: WKNavigationDelegate
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        NSLog("Start")
    }
    
    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        NSLog("Failed Navigation %@", error.localizedDescription)
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        
        if (url == "navigation/index.html") {
            delay(0.1) {
                self.loadingImageView?.removeFromSuperview()
                print("showing")
            }
        }
        
        NSLog("Finish Navigation")
        NSLog("Title:%@ URL:%@", webView.title!, webView.URL!)
        // Disable selection
        webView.evaluateJavaScript("document.documentElement.style.webkitUserSelect='none';", completionHandler: nil);
        webView.evaluateJavaScript("document.documentElement.style.webkitTouchCallout='none';", completionHandler: nil);
    }
}
