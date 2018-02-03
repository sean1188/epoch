//
//  FeedCell.swift
//  portfolio-spectrogram
//
//  Created by Sean Lim on 22/1/18.
//  Copyright © 2018 cool. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import AVFoundation

class FeedCell: UITableViewCell, AVAudioPlayerDelegate {
	
	@IBOutlet var indicator: UIImageView!
	@IBOutlet var userNameField: UILabel!
	@IBOutlet var timeField: UILabel!
	@IBOutlet var activityIndicator: NVActivityIndicatorView!
	
	var sound: Data?
	var audioPlayer = AVAudioPlayer()
	var audioURL: String?
	
	override func awakeFromNib() {
		
	}
	
	func loadData(post: Gram?){
		indicator.image = #imageLiteral(resourceName: "indicator1")
		if let postdata = post {
			let username = postdata["user_name"] as! String
			userNameField.text = (username == user_name) ? "You": "@\(username)"
			// Post time
			timeField.text = Date().offset(from:postdata["time"] as! Date).uppercased()
			audioURL = postdata["audio_url"] as! String
		}
		
	}
	
	func selected() {
		// Animate selected
		if let d = sound as Data! {
			animatePlaying()
			animateSelected()
			do {
				try audioPlayer = AVAudioPlayer.init(data: d)
				if !audioPlayer.isPlaying {
					audioPlayer.delegate = self
					audioPlayer.play()
				}
			}
			catch {
				print("Error thrown in post audio playback \(error)")
			}
		}
	}
	
	func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
		activityIndicator.stopAnimating()
		DatabaseManager.shared.setPostSeen(withURL: audioURL!)
	}
	
	func animateLoading() {
		activityIndicator.type = .ballScaleRippleMultiple
		activityIndicator.startAnimating()
	}
	
	func animatePlaying() {
		activityIndicator.type = .ballScaleMultiple
		activityIndicator.startAnimating()
	}
	
	// Recursive animation loop
	func animateSelected () {
		UIView.animate(withDuration: 0.8, delay: 0, options: .curveEaseIn, animations: {
			self.backgroundColor = appRed
			self.userNameField.textColor = appGreen
		}, completion: { _ in
			UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
				self.backgroundColor = .black
				self.userNameField.textColor = appRed
			}, completion: { _ in
				self.indicator.image = #imageLiteral(resourceName: "indicator2")
				if (self.audioPlayer.isPlaying){
					self.animateSelected()
				}
			})
		})
	}
	
}
