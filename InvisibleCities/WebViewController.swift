//
//  WebViewController.swift
//  irene3
//
//  Created by Leo on 02.07.14.
//  Copyright (c) 2014 Leo. All rights reserved.
//

import WebKit
import UIKit
import AVFoundation
import Darwin
import Foundation

let π = M_PI

#if DEBUG
    let startURL = "http://pony.local:8000/"
#else
    let startURL = "http://localhost:8116/navigation/index.html"
#endif


class WebViewController: UIViewController, UIGestureRecognizerDelegate, UINavigationBarDelegate, WKNavigationDelegate {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var containerView : UIView!
    
    var webView: WKWebView?
    var curReq: NSURLRequest?
    var isLandscape = true
    var specialRotate = false
    var blackBackground = false
    var allowRotate = false
    var backButton: UIButton?
    var url = startURL
    var isMainView = true
 
    
    
    override func loadView() {
        super.loadView()
        
        println("LOAD VIEW")
        
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
        
        let longPress = UILongPressGestureRecognizer(target: self, action:Selector("onLongPress:"))
        longPress.delegate = self
        let shortTap = UITapGestureRecognizer(target: self, action:Selector("onShortTap:"))
        shortTap.delegate = self
        
        
        self.view.addGestureRecognizer(longPress)
        self.view.addGestureRecognizer(shortTap)
        shortTap.requireGestureRecognizerToFail(longPress)
        
        self.setUrl(self.url)
        
        if (curReq != nil) {
            self.webView!.loadRequest(curReq!);
            self.rotate()
        }
        
        self.createBackButton()
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
    
    override func shouldAutorotate() -> Bool {
        if (self.allowRotate || !self.hasCorrectRotation()) {
            println("allowing autorotate")
            return true
        } else {
            return false
        }
    }
    
    override func supportedInterfaceOrientations() -> Int {
        if (isLandscape) {
            return Int(UIInterfaceOrientationMask.Landscape.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.PortraitUpsideDown.rawValue)
        }
    }
    
    func gestureRecognizer(UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
            return true
    }
    
    func createBackButton() {
        let image = UIImage(named: "backButton")
        let button = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        var size = image?.size
        var point = CGPointMake(35, 0);
        button.frame = CGRect(origin: point, size: size!)
        button.setImage(image, forState: .Normal)
        if (self.isMainView) {
            button.alpha = 0;
        }
        button.addTarget(self, action: "popNavigationController:", forControlEvents: UIControlEvents.TouchUpInside)
        self.backButton = button
        self.view.addSubview(button)
    }
    
    func popNavigationController(sender: UIButton!) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func urlFromPart(part: String) -> String {
        var server = "http://localhost:8116"
        var file = "index.html"
        return server + part + "/" + file
    }
    
    func setUrl(urlstring: String) {
        self.url = urlstring;
        let url = NSURL(string: urlstring)
        curReq = NSURLRequest(URL: url!)
    }
    
    func setUrlFromPart(part: String) {
        var urlstring = self.urlFromPart(part)
        self.isMainView = false
        self.setUrl(urlstring)
    }
    
    func setLandscape(land: Bool) {
        self.isLandscape = land
    }
    
    func setSpecialRotate(rotate: Bool) {
        self.specialRotate = rotate
    }
    
    func hasCorrectRotation() -> Bool {
        var device: UIDeviceOrientation = UIDevice.currentDevice().orientation
        var interface: UIInterfaceOrientation = UIApplication.sharedApplication().statusBarOrientation
        
        // Nothing to in these cases
        if (device.isFlat || !device.isValidInterfaceOrientation || device == UIDeviceOrientation.Unknown) {
            return true
        }
        
        // Simple cases: Interface is not what we want
        if (self.isLandscape && !interface.isLandscape) {
            return false
        }
        if (!self.isLandscape && interface.isLandscape) {
            return false
        }
        
        // Same orientation (portrait/land) but not exactly the same.
        if (interface.isLandscape == device.isLandscape && device.rawValue != interface.rawValue) {
            return false
        }
        
        // What else?
        return true
    }
    
    func rotate () {
        if (!self.hasCorrectRotation()) {
            var value = (self.isLandscape) ? UIInterfaceOrientation.LandscapeLeft.rawValue : UIInterfaceOrientation.Portrait.rawValue
            
            self.allowRotate = true
            
            UIDevice.currentDevice().setValue(value, forKey: "orientation")
            
            self.allowRotate = false
            
            UIViewController.attemptRotationToDeviceOrientation()
        }
        
        if (self.specialRotate) {
            var transform: CGAffineTransform = CGAffineTransformMakeRotation(1.5707963268)
            self.view.transform = transform
        } else {
            var transform: CGAffineTransform = CGAffineTransformMakeRotation(0)
            self.view.transform = transform
        }
    }
    
    func fadeButton(to: CGFloat) {
        self.fadeButton(to, delay: 0, duration: 0.5)
    }

    func fadeButton(to: CGFloat, delay: NSTimeInterval) {
        self.fadeButton(to, delay: delay, duration: 0.5)
    }
    
    func fadeButton(to: CGFloat, delay: NSTimeInterval, duration: NSTimeInterval) {
        println("fading button")
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(duration)
        UIView.setAnimationDelay(delay)
        self.backButton?.alpha = to
        UIView.commitAnimations()
    }
    
    func webView(webView: WKWebView!, didFinishNavigation navigation: WKNavigation!) {
        println("finished navigation")
        self.fadeButton(0, delay: 5)
        // Disable selection
        webView.evaluateJavaScript("document.documentElement.style.webkitUserSelect='none';", completionHandler: nil);
        webView.evaluateJavaScript("document.documentElement.style.webkitTouchCallout='none';", completionHandler: nil);
    }
    
    func webView(webView: WKWebView!, decidePolicyForNavigationAction navigationAction: WKNavigationAction,
        decisionHandler: (WKNavigationActionPolicy) -> Void) {
            println(navigationAction.request.URL.scheme)
            if (navigationAction.request.URL.scheme == "thepony") {
                decisionHandler(WKNavigationActionPolicy.Cancel);
                var data = [String: AnyObject]();
                data["path"] = navigationAction.request.URL.path;
                if let query = navigationAction.request.URL.query {
                    let queryArr = split(query, { $0 == "&"})
                    for param in queryArr {
                        let splitParams = split(param, { $0 == "="});
                        var name = "";
                        name = splitParams[0];
                        var isTrue = (splitParams[1] == "true");
                        data.updateValue(isTrue, forKey: name)
                    }
                }
                self.performSegueWithIdentifier("goToContent", sender: data)
                
            } else {
                 decisionHandler(WKNavigationActionPolicy.Allow);
            }
    }
    
    @IBAction func onLongPress(sender: AnyObject) {
        println("long press, showing button");
        self.fadeButton(1)
        var time = dispatch_time(DISPATCH_TIME_NOW, Int64(10 * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue(), {
            self.fadeButton(0)
        })
    }
    
    @IBAction func onShortTap(sender: AnyObject) {
        println("short tap")
        self.fadeButton(0)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dict = sender as? Dictionary<String, AnyObject> {
            let path = dict["path"] as String;
            let landscape = dict["landscape"] as Bool;
            let specialRotate = dict["specialRotate"] as Bool;
            
            if let destination = segue.destinationViewController as? WebViewController {
                destination.setUrlFromPart(path)
                destination.setSpecialRotate(specialRotate)
            }
        }
    }
}
