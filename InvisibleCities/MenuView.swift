//
//  MenuView.swift
//  InvisibleCities
//
//  Created by Leo Koppelkamm on 24/12/14.
//  Copyright (c) 2014 Leo. All rights reserved.
//

import UIKit

class MenuView: UIViewController, UIGestureRecognizerDelegate, UINavigationBarDelegate {
    
    @IBOutlet var containerView : UIView? = nil
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
}