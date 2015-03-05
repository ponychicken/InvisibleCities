//
//  ProjectView.swift
//  InvisibleCities
//
//  Created by Leo Koppelkamm on 05/03/15.
//  Copyright (c) 2015 Leo. All rights reserved.
//

import Foundation
import WebKit

class ContentViewController: NavigationViewController, UIGestureRecognizerDelegate {
    
    var backButton: UIButton?

    
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
    }
    
    //
    // Create back button
    //
    
    func createBackButton() {
        let image = UIImage(named: "backButton")
        let button = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        var size = image?.size
        var point = CGPointMake(35, 0);
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
        println("fading button")
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(duration)
        UIView.setAnimationDelay(delay)
        self.backButton?.alpha = to
        UIView.commitAnimations()
    }
    
    //
    // Gesture recognizers to show back button
    //
    
    func gestureRecognizer(UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
            return true
    }
    
    func onLongPress(sender: AnyObject) {
        println("long press, showing button");
        self.fadeButton(1)
        var time = dispatch_time(DISPATCH_TIME_NOW, Int64(10 * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue(), {
            self.fadeButton(0)
        })
    }
    
    func onShortTap(sender: AnyObject) {
        println("short tap")
        self.fadeButton(0)
    }
    
    //
    // Hide back button after 5 seconds
    //

    override func webView(webView: WKWebView!, didFinishNavigation navigation: WKNavigation!) {
        super.webView(webView, didFinishNavigation: navigation!)
        var time = dispatch_time(DISPATCH_TIME_NOW, Int64(5 * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue(), {
            self.fadeButton(0)
        })
    }
    
    // 
    // URL Stuff
    //
    
    func urlFromPart(part: String) -> String {
        var server = "http://localhost:8116"
        var file = "index.html"
        return server + part + "/" + file
    }
    func setUrlFromPart(part: String) {
        var urlstring = self.urlFromPart(part)
        self.setUrl(urlstring)
    }
    
    //
    // Rotation stuff
    //
    
    func setLandscape(land: Bool) {
        self.isLandscape = land
    }
    
    func setSpecialRotate(rotate: Bool) {
        self.specialRotate = rotate
    }
    
}