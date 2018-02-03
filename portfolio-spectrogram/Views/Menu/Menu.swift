//
//  Meny.swift
//  portfolio-spectrogram
//
//  Created by Sean Lim on 19/1/18.
//  Copyright © 2018 cool. All rights reserved.
//

import Foundation
import SwiftySound
import AVFoundation
import FirebaseAuth
import NVActivityIndicatorView


class Menu: UIViewController {
	
	@IBOutlet var overlayLabel: UILabel!
	@IBOutlet var header: UIView!
	var recorder: AVAudioRecorder!
	var soundFileURL: URL?
	var gramData: Grams?
	var device = UIDevice.current
	
	private let refreshControl = UIRefreshControl()
	
	// Quick hack for channel switch watching
	var channelBuff: String?
	
	
	// Robust Proximity state
	var proximityCovered: Bool!
	
	//Header
	@IBOutlet var channelLabel: UILabel!
	
	@IBOutlet var tableView: UITableView!
	
	@IBOutlet var activityIndicator: NVActivityIndicatorView!
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
	
}

extension Menu {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Add refresh control
		if #available(iOS 10.0, *) {
			tableView.refreshControl = refreshControl
		} else {
			tableView.addSubview(refreshControl)
		}
		// refresh target
		refreshControl.addTarget(self, action: #selector(Menu.fetch), for: .valueChanged)

		// Styling
		styling()
		
		// Recorder permission
		getPermissionForRecorder()
		
		// Setup proximity sensor
		setupProximitySensor()

		setsViewLoading("👋 Welcome Back!")
		
		self.fetch()
		
	}

	@objc func fetch () {
		// Get current user
		self.header.interactAnimation()
		self.channelLabel.text = (channel ?? "FEED").uppercased()
		self.channelBuff = channel
		DatabaseManager.shared.getCurrentUserProfile { succ in
			DatabaseManager.shared.getPosts { (succ , grams) in
				print("Got \(grams!.count) posts")
				if grams!.count == 0 {
					self.overlayLabel.text = "🤷‍♂️ No posts to show..."
					self.overlayLabel.alpha = 1
					self.refreshControl.endRefreshing()
				}
				else {
					self.overlayLabel.alpha = 0
				}
				self.gramData = grams!
				audioData = [:]
				self.tableView.reloadData()
				self.refreshControl.endRefreshing()
				self.activityIndicator.stopAnimating()
				UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseIn, animations: {
					self.tableView.alpha = 1

				}, completion: nil)

			}
		}
	}
	
	private func styling() {
		tableView.rowHeight = 0.1 * self.view.bounds.height	
		refreshControl.backgroundColor = appGreen
		refreshControl.tintColor = appRed
	}
	
	// Posts current recording in buffer
	func post() {
		setsViewLoading("🙆‍♂️ Uploading your cool stuff...")
		StorageManager.shared.uploadFile(url: soundFileURL, sender: self) { (md) in
			self.soundFileURL = nil
			DatabaseManager.shared.makeNewPost(url: md.path) { succ in
				self.fetch()
				self.recorder = nil
			}
		}
	}
	

}

extension Menu {
	// User feedback
	func setsViewLoading(_ message: String?) {
		UIView.animate(withDuration: 0.3) {
			self.tableView.alpha = 0
		}
		self.activityIndicator.startAnimating()
		self.overlayLabel.alpha = 1
		self.overlayLabel.text = message ?? "Working..."
	}
	
	@IBAction func didPanLeft(_ sender: Any) {
		self.showSideMenu()
	}
	
	@IBAction func swipeLeft(_ sender: Any) {
		self.showSideMenu()
	}
	
	private func showSideMenu() {
		self.performSegue(withIdentifier: "leftMenu", sender: self)
	}
}



