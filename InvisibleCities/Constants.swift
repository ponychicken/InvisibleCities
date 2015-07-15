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