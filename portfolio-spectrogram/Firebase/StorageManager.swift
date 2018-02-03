//
//  Storage.swift
//  portfolio-spectrogram
//
//  Created by Sean Lim on 19/1/18.
//  Copyright © 2018 cool. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseStorage

final class StorageManager {
	
	static let shared = StorageManager()
	
	let storage = Storage.storage()

	func uploadFile(url: URL?, sender: UIViewController, callback: @escaping (_ md: StorageMetadata) -> Void) {
		let uid = NSUUID().uuidString
		let feedRef = storage.reference().child("feed/\(uid).m4a")
		feedRef.putFile(from: url!, metadata: nil) { (md, e) in
			if e == nil {
				callback(md!)
			}
			else {
				print(e)
				self.storageError(sender: sender)
			}
		}
	}
	
	func getRecordingData(url: URL, sender: UIViewController, callback: @escaping (_ data: Data) -> Void) {
		let feedRef = storage.reference().child(url.path)
		feedRef.getData(maxSize: 6 * 1024 * 1024) { (data, err) in
			if let _ = err as Error! {
				print(err)
				self.storageError(sender: sender)
			}
			else {
				callback(data!)
			}
		}
	}
	
	private func storageError(sender: UIViewController) {
		AlertManager.newAlert.to(sender).withTitle(":(").withMessage("Something went wrong...").addAction("Dismiss", withCallback: { _ in
			
		}).throwsAlert()
	}
	
}
