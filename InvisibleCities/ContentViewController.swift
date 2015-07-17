//
//  ProjectView.swift
//  InvisibleCities
//
//  Created by Leo Koppelkamm on 05/03/15.
//  Copyright (c) 2015 Leo. All rights reserved.
//

import Foundation
import WebKit

let π = M_PI

class ContentViewController: NavigationViewController, UIGestureRecognizerDelegate {
    
    var backButton: UIButton?
    var isLandscape = true
    var specialRotate = false
    var allowRotate = false
    
    override func loadView() {
        super.loadView()
        
        let longPress = UILongPressGestureRecognizer(target: self, action:Selector("onLongPress:"))
        longPress.delegate = self
        let shortTap = UITapGestureRecognizer(target: self, action:Selector("onShortTap:"))
        shortTap.delegate = self
        
        
        self.view.addGestureRecognizer(longPress)
        self.view.addGestureRecognizer(shortTap)
        shortTap.requireGestureRecognizerToFail(longPress)
        
        self.createBackButton()
        self.rotate()
        
    }
    
    //
    // Create back button
    //
    
    func createBackButton() {
        let image = UIImage(named: "backButton")
        let button = UIButton(type: UIButtonType.Custom)
        let size = image?.size
        let point = CGPointMake(35, 0);
        button.frame = CGRect(origin: point, size: size!)
        button.setImage(image, forState: .Normal)
        button.addTarget(self, action: "popNavigationController:", forControlEvents: UIControlEvents.TouchUpInside)
        self.backButton = button
        self.view.addSubview(button)
    }
    
    //
    // Target method triggered by back button
    // 
    
    func popNavigationController(sender: UIButton!) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //
    // Animation methods to hide/show back button
    //
    
    func fadeButton(to: CGFloat) {
        self.fadeButton(to, delay: 0, duration: 0.5)
    }
    
    func fadeButton(to: CGFloat, delay: NSTimeInterval) {
        self.fadeButton(to, delay: delay, duration: 0.5)
    }
    
    func fadeButton(to: CGFloat, delay: NSTimeInterval, duration: NSTimeInterval) {
        print("fading button")
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(duration)
        UIView.setAnimationDelay(delay)
        self.backButton?.alpha = to
        UIView.commitAnimations()
    }
    
    //
    // Gesture recognizers to show back button
    //
    
    func gestureRecognizer(_: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
            return true
    }
    
    func onLongPress(sender: AnyObject) {
        print("long press, showing button");
        self.fadeButton(1)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(10 * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue(), {
            self.fadeButton(0.4)
        })
    }
    
    func onShortTap(sender: AnyObject) {
        print("short tap")
        self.fadeButton(0.4)
    }
    
    //
    // Hide back button after 5 seconds
    //

    override func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        super.webView(webView, didFinishNavigation: navigation!)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(5 * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue(), {
            self.fadeButton(0.4)
        })
    }
    
    // 
    // URL Stuff
    //
    
    func urlFromPart(part: String) -> String {
        let file = "index.html"
        if (needsServer) {
            return "http://localhost:8116" + part + "/" + file
        } else {
            return part.substringFromIndex(advance(part.startIndex, 1)) +  "/" + file
        }
    }
    
    func setUrlFromPart(part: String) {
        print(part)
        self.url = self.urlFromPart(part)
        print(self.url)
        if (iOS8 || needsServer) {
            self.createReqFromUrl(part)
        }
    }
    
    //
    // Rotation stuff
    //
    
    func setLandscape(land: Bool) {
        self.isLandscape = land
    }
    
    override func shouldAutorotate() -> Bool {
        if (self.allowRotate || !self.hasCorrectRotation()) {
            print("allowing autorotate")
            return true
        } else {
            return false
        }
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if (isLandscape) {
            return UIInterfaceOrientationMask.Landscape
        } else {
            return UIInterfaceOrientationMask.PortraitUpsideDown
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
            let value = (self.isLandscape) ? UIInterfaceOrientation.LandscapeLeft.rawValue : UIInterfaceOrientation.Portrait.rawValue
            
            self.allowRotate = true
            
            UIDevice.currentDevice().setValue(value, forKey: "orientation")
            
            self.allowRotate = false
            
            UIViewController.attemptRotationToDeviceOrientation()
        }
        
        if (self.specialRotate) {
            let transform: CGAffineTransform = CGAffineTransformMakeRotation(1.5707963268)
            self.view.transform = transform
        } else {
            let transform: CGAffineTransform = CGAffineTransformMakeRotation(0)
            self.view.transform = transform
        }
    }
    

}