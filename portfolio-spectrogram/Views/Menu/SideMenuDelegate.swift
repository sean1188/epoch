//
//  SideMenuDelegate.swift
//  portfolio-spectrogram
//
//  Created by Sean Lim on 26/1/18.
//  Copyright © 2018 cool. All rights reserved.
//

import Foundation
import UIKit
import SideMenu

extension Menu: UISideMenuNavigationControllerDelegate{
//	func sideMenuWillAppear(menu: UISideMenuNavigationController, animated: Bool) {
//		print("SideMenu Appearing! (animated: \(animated))")
//	}
	
	func sideMenuDidAppear(menu: UISideMenuNavigationController, animated: Bool) {
		device.isProximityMonitoringEnabled = false
	}
	
//	func sideMenuWillDisappear(menu: UISideMenuNavigationController, animated: Bool) {
//		print("SideMenu Disappearing! (animated: \(animated))")
//	}
	
	func sideMenuDidDisappear(menu: UISideMenuNavigationController, animated: Bool) {
		device.isProximityMonitoringEnabled = true
		if self.channelBuff != channel {
			self.fetch()
		}
	}
}
