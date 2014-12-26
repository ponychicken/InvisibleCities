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
    
    override func loadView() {
        super.loadView()
        
        var config = WKWebViewConfiguration()
        config.mediaPlaybackAllowsAirPlay = true;
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
        return false
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

    
    func setUrl(part: String) {

        var urlstring = "http://localhost:8116" + part
        
        println(urlstring)
        
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
    
    func rotate () {
        var orientation: UIDeviceOrientation = UIDevice.currentDevice().orientation
        
        var deviceIsLandscape = (orientation == UIDeviceOrientation.LandscapeLeft || orientation == UIDeviceOrientation.LandscapeRight)
        
        var deviceIsPortrait = (orientation == UIDeviceOrientation.Portrait || orientation == UIDeviceOrientation.PortraitUpsideDown)
        
        if (self.isLandscape && deviceIsPortrait) {
            let value = UIInterfaceOrientation.LandscapeLeft.rawValue
            UIDevice.currentDevice().setValue(value, forKey: "orientation")
        } else if (!self.isLandscape && deviceIsLandscape) {
            let value = UIInterfaceOrientation.Portrait.rawValue
            UIDevice.currentDevice().setValue(value, forKey: "orientation")
        }
        
        UIViewController.attemptRotationToDeviceOrientation()
        
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

