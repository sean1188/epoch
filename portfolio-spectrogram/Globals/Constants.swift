//
//  Constants.swift
//  portfolio-spectrogram
//
//  Created by Sean Lim on 19/1/18.
//  Copyright © 2018 cool. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

let appdelegate = UIApplication.shared.delegate as! AppDelegate

// User globals
var user: User?

var user_name: String?
var subscribed: [String]?
var channel: String? = "feed"

typealias Gram = [String: Any?]
typealias Grams = [Gram]

typealias emptyBlock = (_ : Bool) -> Void
let empty: emptyBlock? = nil
var audioData: [Int : Data] = [:]

// Colors
let appYellow = UIColor(red:1.00, green:0.92, blue:0.00, alpha:1.0)
let appGreen = UIColor(red:0.00, green:0.86, blue:0.43, alpha:1.0)
let appRed = UIColor(red:1.00, green:0.00, blue:0.40, alpha:1.0)
let appBlack = UIColor(red:0.10, green:0.10, blue:0.10, alpha:1.0)
let appBlue = UIColor(red:0.00, green:0.60, blue:0.76, alpha:1.0)


// Secrets
var fcm_key: String?
