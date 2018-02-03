//
//  Table.swift
//  portfolio-spectrogram
//
//  Created by Sean Lim on 22/1/18.
//  Copyright © 2018 cool. All rights reserved.
//

import Foundation
import UIKit

extension Menu: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! FeedCell
		cell.alpha = 0
		UIView.animate(withDuration: 0.6) {
			cell.alpha = 1
		}
		let postdata = gramData?[indexPath.row]
		cell.loadData(post: postdata)
		
		let soundURL = URL.init(string: postdata!["audio_url"] as! String)
		
		// Load audio
		if audioData[indexPath.row] == nil {
			cell.animateLoading()
			StorageManager.shared.getRecordingData(url: soundURL!, sender: self) { d in
				audioData[indexPath.row] = d
//				print("Added data for recording at \(indexPath.row), \(audioData)")
				cell.sound = d
				cell.activityIndicator.stopAnimating()
			}
		}
		else {
			// Cached
//			print("cached, not loading")
			cell.sound = audioData[indexPath.row]
		}
		return cell
	}
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return gramData?.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath) as! FeedCell
		cell.selected()
	}
}
