//
//  AppDelegate.swift
//  portfolio-spectrogram
//
//  Created by Sean Lim on 17/1/18.
//  Copyright © 2018 cool. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManager
import FirebaseAuth
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		
		// Firebase
		FirebaseApp.configure()
		
		// Initialize Keyboard Manager
		IQKeyboardManager.shared().isEnabled = true
		
		// get fcm key
		if let secretsPath = Bundle.main.path(forResource: "secrets", ofType: "plist") {
			fcm_key = NSDictionary(contentsOfFile: secretsPath)?.object(forKey: "fcm_key") as! String
			print("fcm key : \(fcm_key)")
		}
		else {
			print("WARNING: Couldn't read secrets")
		}
		
		
		// Push Notifications
		if #available(iOS 10.0, *) {
			// For iOS 10 display notification (sent via APNS)
			UNUserNotificationCenter.current().delegate = self
			
			let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
			UNUserNotificationCenter.current().requestAuthorization(
				options: authOptions,
				completionHandler: {_, _ in })
		} else {
			let settings: UIUserNotificationSettings =
				UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
			application.registerUserNotificationSettings(settings)
		}
		
		application.registerForRemoteNotifications()

		
		user = Auth.auth().currentUser
		
		// Routing
		window?.rootViewController = UIStoryboard(name: "Main", bundle: nil)
			.instantiateViewController(withIdentifier:(user != nil) ? "Menu":"Login")
		return true
	}
	
	func reset() {
		user = Auth.auth().currentUser
		UIView.animate(withDuration: 0.4, animations: {
			self.window?.alpha = 0
		}) { _ in
			self.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil)
				.instantiateViewController(withIdentifier:(FirebaseAuth.Auth.auth().currentUser != nil) ? "Menu":"Login")
			UIView.animate(withDuration: 0.4 , animations: {
				self.window?.alpha = 1
			})
		}
		
	}
	
	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		Messaging.messaging().setAPNSToken(deviceToken, type: .sandbox)
		Messaging.messaging().subscribe(toTopic: "all")

	}
	

}

