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

let π = M_PI

class WebViewController: UIViewController, UIGestureRecognizerDelegate, UINavigationBarDelegate, WKNavigationDelegate {
    
    @IBOutlet var containerView : UIView? = nil
    
    var webView: WKWebView?
    var curReq: NSURLRequest?
    var isLandscape = true
    var specialRotate = false
    var blackBackground = false
    var allowRotate = false
    
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
        
        self.view = self.webView
        
        let recognizer = UILongPressGestureRecognizer(target: self, action:Selector("showBar:"))
        recognizer.delegate = self
        
        self.view.addGestureRecognizer(recognizer)
        
        if (curReq != nil) {
            self.webView!.loadRequest(curReq!);
            self.rotate()
            self.colorBackground()
        }
        
        
        self.setupNavBar()
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
        println("mem warn")
        
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
    
    func urlFromPart(part: String) -> String {
        var server = "http://192.168.2.1"
        var file = "index.html"
        return server + "/" + part + "/" + file
    }
    
    func setUrl(part: String) {
        
        var urlstring = self.urlFromPart(part)
        
        var url = NSURL(string: urlstring)
        
        curReq = NSURLRequest(URL: url!)
    }
    
    func setLandscape(land: Bool) {
        self.isLandscape = land
    }
    
    func setSpecialRotate(rotate: Bool) {
        self.specialRotate = rotate
    }
    
    func setBackground(black: Bool) {
        self.blackBackground = black
    }
    
    func colorBackground() {
        if (self.blackBackground) {
            self.view.backgroundColor = UIColor.blackColor()
            self.webView?.scrollView.backgroundColor = UIColor.blackColor()
            
        } else {
            self.view.backgroundColor = UIColor.whiteColor()
            self.webView?.scrollView.backgroundColor =  UIColor.whiteColor()
        }
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
    
    func fadeBar(to: CGFloat) {
        self.fadeBar(to, delay: 0)
    }
    
    func fadeBar(to: CGFloat, delay: NSTimeInterval) {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.5)
        UIView.setAnimationDelay(delay)
        self.navigationController?.navigationBar.alpha = to
        UIView.commitAnimations()
        self.navigationController?.navigationBar.frame = CGRectMake(40, 10, 150, 45)
    }
    
    func webView(webView: WKWebView!, didFinishNavigation navigation: WKNavigation!) {
        self.fadeBar(0, delay: 1)
    }
    
    func setupNavBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        var navBar: UINavigationBar? = self.navigationController?.navigationBar
        
        var bounds: CGRect? = navBar?.bounds
        
        navBar?.bounds = bounds!
        navBar?.frame = CGRectMake(40, 10, 150, 45)

        
        navBar?.tintColor = UIColor.whiteColor()
        navBar?.barTintColor = UIColor.blackColor()
    }
    
    
    @IBAction func showBar(sender: AnyObject) {
        self.fadeBar(1)
        //self.fadeBar(0, delay: 3)
    }
    
    
}

