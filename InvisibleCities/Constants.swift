//
//  Constants.swift
//  InvisibleCities
//
//  Created by Leo on 15.07.15.
//  Copyright © 2015 Leo. All rights reserved.
//

import Foundation

let Device = UIDevice.currentDevice()

private let iosVersion = NSString(string: Device.systemVersion).doubleValue

let iOS9 = iosVersion >= 9 && iosVersion < 10
let iOS8 = iosVersion >= 8 && iosVersion < 9
let iOS7 = iosVersion >= 7 && iosVersion < 8


func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

func splashImageForOrientation(orientation: UIInterfaceOrientation, size: CGSize) -> String? {
    var viewSize        = size
    var viewOrientation = "Portrait"
    
    if UIInterfaceOrientationIsLandscape(orientation) {
        viewSize        = CGSizeMake(size.height, size.width)
        viewOrientation = "Landscape"
    }
    
    if let imagesDict = NSBundle.mainBundle().infoDictionary {
        if let imagesArray = imagesDict["UILaunchImages"] as? [[String: String]] {
            for dict in imagesArray {
                if let sizeString = dict["UILaunchImageSize"], let imageOrientation = dict["UILaunchImageOrientation"] {
                    let imageSize = CGSizeFromString(sizeString)
                    if CGSizeEqualToSize(imageSize, viewSize) && viewOrientation == imageOrientation {
                        if let imageName = dict["UILaunchImageName"] {
                            return imageName
                        }
                    }
                }
            }
        }
    }
    
    return nil
    
}