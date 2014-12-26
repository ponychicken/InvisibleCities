//
//  NavDelegate.swift
//  InvisibleCities
//
//  Created by Leo Koppelkamm on 25/12/14.
//  Copyright (c) 2014 Leo. All rights reserved.
//

import Foundation

import UIKit

class NavDelegate: UINavigationController, UINavigationBarDelegate {
    func positionForBar(id: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.Any
    }
    
    override func shouldAutorotate() -> Bool {        
        if let viewController = self.visibleViewController as? WebViewController {
            return viewController.shouldAutorotate()
        } else {
            return true
        }

    }
}