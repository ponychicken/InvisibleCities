//
//  ViewController.swift
//  irene3
//
//  Created by Leo on 02.07.14.
//  Copyright (c) 2014 Leo. All rights reserved.
//

import WebKit
import UIKit
import AVFoundation



class ViewController: UIViewController {
    
    @IBOutlet var containerView : UIView? = nil
    
    var webView: WKWebView?
    
    
    
    override func loadView() {
        super.loadView()
        
        let webServer = GCDWebServer()
        
        var docRoot = NSBundle.mainBundle().pathForResource("start", ofType: ".html", inDirectory: "Cities");
        docRoot = docRoot?.stringByDeletingLastPathComponent;
        
        webServer.addGETHandlerForBasePath("/", directoryPath: docRoot, indexFilename: "start.html", cacheAge: 3600, allowRangeRequests: true)
        
        webServer.startWithPort(8000, bonjourName: nil)
        
        var config = WKWebViewConfiguration()
        config.mediaPlaybackAllowsAirPlay = true;
        config.mediaPlaybackRequiresUserAction = false;
        config.allowsInlineMediaPlayback = true;
        
        self.webView = WKWebView(
            frame: self.view.bounds,
            configuration: config
        )
        
        self.view = self.webView
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
        
        
        var setCategoryError: NSError?
        
        let audioSession = AVAudioSession.sharedInstance()
        
        var ok = audioSession.setCategory(AVAudioSessionCategoryPlayback,
            error: &setCategoryError
        )
        
        if (!ok) {
            println("Error setting AVAudioSessionCategoryPlayback: \(setCategoryError)")
        }

        var url = NSURL(string: "http://localhost:8000/Dom/Zirma.html")
        
        var req = NSURLRequest(URL: url!)
        
        self.webView!.loadRequest(req)
    }
    
    override func didReceiveMemoryWarning() {
        println("mem warn")
        
        NSURLCache.sharedURLCache().removeAllCachedResponses()
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
}

