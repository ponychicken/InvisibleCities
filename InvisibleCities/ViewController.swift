//
//  ViewController.swift
//  irene3
//
//  Created by Leo on 02.07.14.
//  Copyright (c) 2014 Leo. All rights reserved.
//

import WebKit
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var containerView : UIView = nil
    
    var webView: WKWebView?
    
    override func loadView() {
        super.loadView()
        self.webView = WKWebView()
        self.view = self.webView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //var url = NSURL(string:"http://haec.local");
        //, inDirectory: "html_files"
        
        var path = NSBundle.mainBundle().pathForResource("index", ofType: ".html", inDirectory: "Perinthia");
        
        var url = NSURL(fileURLWithPath: path, isDirectory: false);
        
        var req = NSURLRequest(URL:url)
        self.webView!.loadRequest(req)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

