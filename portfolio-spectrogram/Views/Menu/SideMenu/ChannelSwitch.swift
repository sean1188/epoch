//
//  ChannelSwicth.swift
//  portfolio-spectrogram
//
//  Created by Sean Lim on 26/1/18.
//  Copyright © 2018 cool. All rights reserved.
//

import Foundation
import UIKit

extension MainSideMenu {
	func switchChannel() {
		// Switch channel
		channelSwitchView.frame = self.view.frame.offsetBy(dx: 0, dy: 2 * self.view.bounds.height)
		self.view.addSubview(channelSwitchView)
		UIView.animate(withDuration: 0.5, animations: {
			self.channelSwitchView.frame = self.view.frame
		})
	}
	@IBAction func channelSwitchAction(_ sender: Any) {
		channel = (channelSwitchField.text == "") ? "feed": channelSwitchField.text
		self.dismiss(animated: true) {
		}
	}
	@IBAction func defaultChannel(_ sender: Any) {
		channel = "feed"
		self.dismiss(animated: true) {
		}
	}
	@IBAction func channelSwitchCancelled(_ sender: Any) {
		UIView.animate(withDuration: 0.5, animations: {
			self.channelSwitchView.transform = CGAffineTransform.init(translationX: 0, y: self.view.bounds.height)
		}) { _ in
					self.channelSwitchView.removeFromSuperview()
		}
	}
}
