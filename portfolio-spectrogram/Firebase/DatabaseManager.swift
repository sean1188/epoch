//
//  DB.swift
//  portfolio-spectrogram
//
//  Created by Sean Lim on 20/1/18.
//  Copyright © 2018 cool. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseDatabase
import FirebaseAuth
import FirebaseMessaging
import SwiftClient

final class DatabaseManager {
	
	static let shared = DatabaseManager()
	
	let databaseUserRef = Database.database().reference().child("user_profile")
	
	func databaseFeedRef() -> DatabaseReference {
		return Database.database().reference().child(channel!).child(Date().formatDay())
	}
	
	// Makes new post in DB
	func makeNewPost(url: String?, callback: @escaping (_ succ: Bool) -> Void) {
		databaseFeedRef().child("\(user!.uid)").childByAutoId().setValue([
			"user_name": user_name!,
			"audio_url": url!,
			"time": Date().stringFromDate()
		], andPriority: nil) { (e, dref) in
			print(e)
			// Sends push notification
			self.broadcastActivity()
			callback(e == nil)
		}
	}
	
	// Retrieves all posts
	func getPosts(completion: @escaping (_ succ: Bool,_ grams: Grams?) -> Void) {
		let seenLinks: [String]  = (UserDefaults.standard.array(forKey: "seen")  ?? []) as! [String]
		var fetchQueue = subscribed
		fetchQueue?.append(user!.uid)
		getFeed(forUsers: fetchQueue!) { (s, d) in
			
			// Transforms fetched data in main thread to improve responsiveness
			DispatchQueue.main.async {
				let sortedGrams = d?.map({ gram -> Gram in
					var n = gram
					n["time"] = (gram["time"] as! String).dateFromString()
					return n
				}).filter({ (gram) -> Bool in
					
					if seenLinks.contains(gram["audio_url"] as! String)  {
						return false
					}
					else {
						return true
					}
				}).sorted(by: {($0["time"] as! Date).compare($1["time"] as! Date) == .orderedDescending})
				
				completion(s,sortedGrams)
			}
			
		}
	}
	
	// Recursive get for all following
	private func getFeed(forUsers: [String], _ gramStack: Grams = [], completion: @escaping (_ succ: Bool, _ data: Grams?) -> Void){
		var users = forUsers
		var grams: Grams = gramStack
		if users.count >= 1 {
			databaseFeedRef().child(users.popLast()!).observe(.value, with: { data in
				print("Fetched \(data.childrenCount) posts")
				data.children.forEach{
					grams.append(($0 as! DataSnapshot).value as! Gram)
				}
				self.getFeed(forUsers: users, grams, completion: completion)
			}) { (e) in
				print(e)
				self.getFeed(forUsers: users, grams, completion: completion)
			}
		}
		else{
			print(grams)
			completion(true, grams)
		}
	}
	
	// Temp not going to implement callbacks
	func setPostSeen(withURL: String) {
		var seen = UserDefaults.standard.array(forKey: "seen") ?? []
		seen.append(withURL)
		UserDefaults.standard.setValue(seen, forKey: "seen")
	}
	
	// MARK: -  For Current User
	func getUser(withId: String, callback: @escaping (_ exists: Bool, _ userData: [String: Any]?) -> Void){
		databaseUserRef.child(withId).observe(.value, with: { d in
			callback(true, d.value as! NSDictionary as! [String : Any])
		}) { e in
			print(e)
			callback(false, nil)
		}
	}
	
	func updateCurrentUserProfile(username: String = user_name!, uid: String = (user?.uid)!, callback: @escaping (_ succ: Bool) -> Void) {
		databaseUserRef.child(uid).setValue([
			"user_name": username
		]) { e, dref in
			// handles
			callback(e == nil)
		}
	}
	
	func getCurrentUserProfile(callback: @escaping (_ succ: Bool) -> Void) {
		databaseUserRef.child(user!.uid).observeSingleEvent(of: .value, with: {
			d in
			let val = d.value
			let data = val as? NSDictionary
			let n = data?["user_name"] as? String
			user_name = n
			if data?["subscribed"] != nil {
				subscribed = ((data?["subscribed"] as! [String: Bool]).map{$0.0} as [String])
				subscribed!.forEach{
					Messaging.messaging().subscribe(toTopic: $0)
					print("Subscribed to \($0)")
				}
				
			}
			else {
				subscribed = []
			}
			
			print("Loaded Username: \(n)")
			callback(true)
			
		})
	}
	
	func subscribeToUser(uid: String, callback: @escaping (_ succ: Bool) -> Void	) {
		databaseUserRef.child("\(user!.uid)/subscribed").child(uid).setValue(true) { (err, dbRef) in
			if err != nil {
				print(err)
			}
			else {
				callback(true)
			}
		}
	}
	
	func unsuscribeFromUser(uid: String, callback: @escaping (_ succ: Bool) -> Void) {
		databaseUserRef.child("\(user!.uid)/subscribed/\(uid)").removeValue { (err, dbRef) in
			if err != nil {
				print(err)
			}
			else {
				callback(true)
			}
		}
	}
	
	// Broadcast activity to all followers
	func broadcastActivity() -> Void {
		let client = Client()
			.baseUrl(url: "https://fcm.googleapis.com")
			.onError { (e) in
				print(e)
		}
		
		client.post(url: "/fcm/send")
			.set(headers: [
				"Authorization": "key=\(fcm_key!)",
				"Content-Type": "application/json"
				])
			.send(data: [
				"to" : "/topics/\(user!.uid)",
				"priority" : "high",
				"notification" : [
					"body" : "\(user_name!) just posted on \(channel!)",
					"title" : "New post on \(channel!)"
				]
				])
			.end( done:{ (res) in
				if res.basicStatus == Response.BasicResponseType.ok { // status of 2xx
					print("Broadcast POST: \(res.basicStatus)")
				}
				else {
					print(res.basicStatus)
				}
				
			})
		
	}

}
