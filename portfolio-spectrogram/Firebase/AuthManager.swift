//
//  Auth.swift
//  portfolio-spectrogram
//
//  Created by Sean Lim on 19/1/18.
//  Copyright © 2018 cool. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseCore

final class AuthManager {
	
	static let auth = Auth.auth()
	
	static func loginWith(email: String, pwd: String, Logininstance: Login) {
		auth.signIn(withEmail: email, password: pwd) { (u, e) in
			Logininstance.hideLoadingOverlay()
			// Handles errors
			if e != nil {
				Logininstance.view.animateFailure()
				AlertManager.newAlert.to(Logininstance)
					.withMessage(e?.localizedDescription ?? "An error has occurred.")
				.withTitle("Ooops!")
					.addAction(nil, withCallback: { (a) in
						Logininstance.passwordField.text = ""
					})
				.throwsAlert()
				
			}
			else if !u!.isEmailVerified {
				Logininstance.view.animateFailure()
				AlertManager.newAlert.to(Logininstance)
					.withMessage("Please verify your email")
					.withTitle("Ooops!")
					.addAction(nil, withCallback: { (a) in
						Logininstance.passwordField.text = ""
						
					})
					.throwsAlert()
				// Sends another verification email if user is not verified
				if !u!.isEmailVerified {
					u?.sendEmailVerification(completion: { (e) in
						print("stealth email has been sent")
					})
				}
				// Signs user out (email not verified)
				do { try auth.signOut() } catch {
					print(error)
					
				}
			}
			else {
				// Set user
				user = u
				// Get user state from DB
				DatabaseManager.shared.getCurrentUserProfile(callback: { _ in
					appdelegate.reset()
				})
				
			}
		}
	}
	
	static func logout() {
		do {
			DatabaseManager.shared.databaseFeedRef().child(user!.uid).removeAllObservers()
			DatabaseManager.shared.databaseFeedRef().removeAllObservers()
			DatabaseManager.shared.databaseUserRef.removeAllObservers()
			try auth.signOut()
		}
		catch {
			print(error)
		}
		
		appdelegate.reset()
		
	}
	
	
	static func signUp(email: String, username: String, pwd: String, instance: SignUp, failed: @escaping (_ succ: Bool) -> Void) {
		auth.createUser(withEmail: email, password: pwd) { user, err in
			if let e = err as Error! {
				// Handle Error
				print(e)
				AlertManager.newAlert.to(instance).withTitle("Sign Up Error 😞").withMessage((err?.localizedDescription)!).addAction("Okay", withCallback: { _ in
					
					failed(false)
					
				}).throwsAlert()
			}
			else {
				// Send verification email
				user?.sendEmailVerification(completion: { (e) in
					if e == nil  {
						// Store username
						DatabaseManager.shared.updateCurrentUserProfile(username: username, uid: user!.uid, callback: { (_) in
							AlertManager.newAlert.to(instance).withTitle("👯‍♂️ Welcome to the fam, \(username)").withMessage("A verificaton email has been sent.").addAction("Okay", withCallback: { _ in
								// Dismiss signup instance
								do {
									try auth.signOut()
									appdelegate.reset()
								} catch {
									print(error)
								}
							}).throwsAlert()
							
						})
					}
					else {
						AlertManager.newAlert.to(instance).withTitle("Sign Up Error 😞").withMessage("Verification email was not sent.").addAction("Okay", withCallback: { _ in
							
							failed(false)
							
						}).throwsAlert()
					}
				})
				
				
			}
		}
		}
	}
