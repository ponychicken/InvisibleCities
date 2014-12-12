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
        
        var setCategoryError: NSError?
        
        let audioSession = AVAudioSession.sharedInstance()
        
        var ok = audioSession.setCategory(AVAudioSessionCategoryPlayback,
            error: &setCategoryError
        )
        
        if (!ok) {
            println("Error setting AVAudioSessionCategoryPlayback: \(setCategoryError)")
        }

        
        var path = NSBundle.mainBundle().pathForResource("start", ofType: ".html", inDirectory: "Cities/Dom");
        

        var url = NSURL(fileURLWithPath: path!, isDirectory: false);
        
        var req = NSURLRequest(URL:url!)
        
        self.webView!.loadRequest(req)
    }
    
    override func didReceiveMemoryWarning() {
        println("mem warn")
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

