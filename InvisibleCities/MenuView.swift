//
//  MenuView.swift
//  InvisibleCities
//
//  Created by Leo Koppelkamm on 24/12/14.
//  Copyright (c) 2014 Leo. All rights reserved.
//

import UIKit

class MenuView: UIViewController {
    
    @IBOutlet var containerView : UIView? = nil
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let button = sender as? customButton {
            var url = button.url;
            
            if let destination = segue.destinationViewController as? WebViewController {
                destination.setUrl(url)
                destination.setLandscape(button.landscape)
                destination.setSpecialRotate(button.specialRotate)
                destination.setBackground(button.black)
            }
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
}