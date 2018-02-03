//
//  Proximity.swift
//  portfolio-spectrogram
//
//  Created by Sean Lim on 19/1/18.
//  Copyright © 2018 cool. All rights reserved.
//

import Foundation
import NotificationCenter
import SwiftySound


// MARK: - Proximity Sensor
extension Menu {
	
	func setupProximitySensor() {
		self.proximityCovered = false;
		device.isProximityMonitoringEnabled = true
		if device.isProximityMonitoringEnabled {
			NotificationCenter.default.addObserver(self, selector: #selector(Menu.proximityChanged), name: NSNotification.Name(rawValue: "UIDeviceProximityStateDidChangeNotification"), object: device)
		}
	}
	
	@objc func proximityChanged(notification: NSNotification) {
		
		if recorder == nil && soundFileURL == nil && !proximityCovered {
			// Begin recording
			Sound.play(file: "notif.mp3")
			record(true)
			
		}
		else {
			print("Proximity lifted")
			recorder?.stop()
		}
		
		proximityCovered = !proximityCovered

		
	}
}

