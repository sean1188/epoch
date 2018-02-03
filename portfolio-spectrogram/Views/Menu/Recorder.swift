//
//  Recorder.swift
//  portfolio-spectrogram
//
//  Created by Sean Lim on 19/1/18.
//  Copyright © 2018 cool. All rights reserved.
//

import Foundation
import AVFoundation
import SwiftySound

// MARK: - Audio manager
extension Menu: AVAudioRecorderDelegate {
	
	func getPermissionForRecorder() {
		AVAudioSession.sharedInstance().requestRecordPermission {
			[unowned self] granted in
			if granted {
				print("Permission to record granted")
			}
			else {
				print("Permission to record not granted")
			}
		}
		
		if AVAudioSession.sharedInstance().recordPermission() == .denied {
			print("permission denied")
		}
	}
	
	func record(_ setup: Bool) {
		print("\(#function)")

		self.setSessionPlayAndRecord()
		if setup {
			self.setupRecorder()
		}
		self.recorder.prepareToRecord()
		self.recorder.record()
		
		if AVAudioSession.sharedInstance().recordPermission() == .denied {
			print("permission denied")
		}
	}
	
	
	func setupRecorder() {
		print("\(#function)")
		
		let currentFileName = Date().stringFromDate()
		print(currentFileName)
		
		// Sets soundfile url to current dir
		let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
		self.soundFileURL = documentsDirectory.appendingPathComponent(currentFileName)
		print("writing to soundfile url: '\(soundFileURL!)'")
		
		if FileManager.default.fileExists(atPath: soundFileURL!.absoluteString) {
			// probably won't happen. want to do something about it?
			print("soundfile \(soundFileURL!.absoluteString) exists")
		}
		
		let recordSettings: [String: Any] = [
			AVFormatIDKey: kAudioFormatAppleLossless,
			AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
			AVEncoderBitRateKey: 32000,
			AVNumberOfChannelsKey: 1,
			AVSampleRateKey: 44100.0
		]
		
		
		do {
			recorder = try AVAudioRecorder(url: soundFileURL!, settings: recordSettings)
			recorder.delegate = self
			recorder.isMeteringEnabled = true
			recorder.prepareToRecord() // creates/overwrites the file at soundFileURL
		}
		catch {
			recorder = nil
			print(error.localizedDescription)
		}
		
	}
	
	func setSessionPlayAndRecord() {
		print("\(#function)")
		
		let session = AVAudioSession.sharedInstance()
		do {
			try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
		}
		catch {
			print(error.localizedDescription)
		}
		
		do {
			try session.setActive(true)
		}
		catch {
			print(error.localizedDescription)
		}
	}
	
	func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder,
																			 successfully flag: Bool) {
		
		print("finished recording \(flag)")
		post()
	}
	
	func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder,
																				error: Error?) {
		print("\(#function)")
		
		if let e = error {
			print("\(e.localizedDescription)")
		}
	}
	
}
