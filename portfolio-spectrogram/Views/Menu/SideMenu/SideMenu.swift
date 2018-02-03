//
//  MainSideMenu.swift
//  portfolio-spectrogram
//
//  Created by Sean Lim on 24/1/18.
//  Copyright © 2018 cool. All rights reserved.
//

import Foundation
import UIKit
import QRCode
import QRCodeReader
import AVFoundation
import JVFloatLabeledTextField

// Avoid naming conflict with sideMenu dep
class MainSideMenu: UITableViewController  {
	
	@IBOutlet var channelSwitchView: UIView!
	@IBOutlet var channelSwitchField: JVFloatLabeledTextField!
	
	var menuInstance: Menu?
	
	// Good practice: create the reader lazily to avoid cpu overload during the
	// initialization and each time we need to scan a QRCode
	lazy var readerVC: QRCodeReaderViewController = {
		let builder = QRCodeReaderViewControllerBuilder {
			$0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
		}
		
		return QRCodeReaderViewController(builder: builder)
	}()

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		switch indexPath.row {
		case 0:
			break
		case 1:
			// Present QRScanner
			self.scanAction(self)
		case 2:
			self.switchChannel()
		case 3:
			// Log user out
			self.dismiss(animated: true, completion: {
				AuthManager.logout()
			})
		default:
			break
		}
	}
	
}
