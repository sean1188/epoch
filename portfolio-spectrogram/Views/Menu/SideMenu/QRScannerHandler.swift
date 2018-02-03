//
//  QRScannerHandler.swift
//  portfolio-spectrogram
//
//  Created by Sean Lim on 24/1/18.
//  Copyright © 2018 cool. All rights reserved.
//

import Foundation
import QRCodeReader
import AVFoundation

// Boilerplate delegate methods for QRCode scanner

extension MainSideMenu: QRCodeReaderViewControllerDelegate {
	
	func scanAction(_ sender: AnyObject) {
		// Retrieve the QRCode content
		// By using the delegate pattern
		readerVC.delegate = self
		
		// Presents the readerVC
		readerVC.view.frame = self.view.frame.insetBy(dx: 0, dy: 30)
		readerVC.view.sendSubview(toBack: self.view)
		self.view.addSubview(readerVC.view)
		
	}
	
	// MARK: - QRCodeReaderViewController Delegate Methods
	func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
		reader.stopScanning()
		// Will try suscribe
		suscribe(toUser: result.value)
		
	}
	
	func readerDidCancel(_ reader: QRCodeReaderViewController) {
		reader.stopScanning()
		dismiss(animated: true, completion: nil)
		
	}
	
	// Handles
	private func suscribe(toUser: String){
		if toUser == user!.uid {
			AlertManager.newAlert.to(self).withTitle("Bruh").withMessage("Don't follow yourself...").addAction(":(", withCallback: { _ in
				self.dismiss(animated: true, completion: nil)
			}).throwsAlert()
			return
		}
		else {
			DatabaseManager.shared.getUser(withId: toUser) { (succ, data) in
				if succ {
					AlertManager.newAlert.to(self).withTitle("Booyah!").withMessage("Follow \(data!["user_name"] ?? "")?").addAction("Cancel", withCallback: { _ in
						// Dismiss
						self.dismiss(animated: true, completion: nil)
						
					}).addAction("Yes", withCallback: { _ in
						// Subscribe
						DatabaseManager.shared.subscribeToUser(uid: toUser, callback: { succ in
							print(succ)
							self.dismiss(animated: true, completion: nil)
							
						})
					}).throwsAlert()
					return
				}
				else {
					AlertManager.newAlert.to(self).withTitle("Error").withMessage("User not found").addAction("Okay", withCallback: { _ in
						self.dismiss(animated: true, completion: nil)
						
					}).throwsAlert()
					return
				}
			}
		}
	}
}
