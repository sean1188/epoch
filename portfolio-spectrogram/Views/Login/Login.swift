//
//  Login.swift
//  portfolio-spectrogram
//
//  Created by Sean Lim on 17/1/18.
//  Copyright © 2018 cool. All rights reserved.
//

import Foundation
import UIKit
import JVFloatLabeledTextField
import FirebaseAuth
import FirebaseCore
import SwiftySound

// Model
class Login: BaseViewController {
	
	@IBOutlet var logo: UIImageView!
	@IBOutlet var usernameField: JVFloatLabeledTextField!
	@IBOutlet var passwordField: JVFloatLabeledTextField!
	@IBOutlet var actionButton: UIButton!
	@IBOutlet var signupButton: UIButton!
	
	@IBOutlet var textFieldPadding: [UIView]!
	
	var signUp: SignUp?
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
}



// Controller
extension Login {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		styling()
	}
	
	func styling() {
		logo.addParallaxToView(amount: 40)
	}
	
	@IBAction func buttonPressed(_ sender: UIButton) {
		if sender == actionButton {
			// Login
			if (usernameField.text != "" && passwordField.text != "") {
				if sender == actionButton {
					// Login attempt
					self.view.animateSucceed()
					self.showLoadingOverlay()
					AuthManager.loginWith(email: usernameField.text!, pwd: passwordField.text!, Logininstance: self)
					
				}
				else {
					// Signup attempt
				}
			}
			else {
				AlertManager.newAlert.to(self).withTitle("Invalid input...").withMessage("Please try again").addAction("Okay", withCallback: { _ in
				}).throwsAlert()
				self.view.animateFailure()
			}
		}
		else {
			// Sign up
			self.toggleSignUp()
		}
		
	}
	
	func toggleSignUp () {
		if signUp == nil {
			self.signUp = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "signup") as! SignUp
			self.signUp!.view.alpha = 0
			self.signUp?.loginInstance = self
			self.view.addSubview((self.signUp?.view)!)
			UIView.animate(withDuration: 0.2, animations: {
				self.signUp!.view.alpha = 1
			})
			
		}
		else {
			UIView.animate(withDuration: 0.4, animations: {
				self.signUp!.view.alpha = 0
			})
			
			self.signUp?.removeFromParentViewController()
			self.signUp = nil
			
		}
	}
}
