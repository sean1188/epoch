//
//  SignUp.swift
//  portfolio-spectrogram
//
//  Created by Sean Lim on 25/1/18.
//  Copyright © 2018 cool. All rights reserved.
//

import Foundation
import UIKit
import JVFloatLabeledTextField

class SignUp: BaseViewController {
	
	@IBOutlet var header: UILabel!

	@IBOutlet var username: JVFloatLabeledTextField!
	@IBOutlet var email: JVFloatLabeledTextField!
	@IBOutlet var password: JVFloatLabeledTextField!
	@IBOutlet var cfm_password: JVFloatLabeledTextField!
	
	var loginInstance: Login?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		styling()
	}
	
	private func styling() {
	}
	
	@IBAction func Back(_ sender: Any) {
		loginInstance!.toggleSignUp()
	}
	
	@IBAction func SignUpPressed(_ sender: Any) {
		if username.text != "" && email.text != "" && password.text !=  ""  && password.text == cfm_password.text {
			self.signUp()
			self.view.animateSucceed()
		}
		else {
			self.view.animateFailure()
			AlertManager.newAlert.to(self).withTitle("Invalid input").withMessage(":(").addAction("Dismiss", withCallback: { _ in
				
			}).throwsAlert()
		}
	}
	
	@IBAction func usernameFieldDidChange(_ sender: Any) {
		if self.username.text == "" {
			self.header.text = "Sign Up"
		}
		else {
			self.header.text = "Welcome,\n\(username.text!)"
		}
	}
}

extension SignUp {
	
	private func signUp() {
		self.showLoadingOverlay()
		AuthManager.signUp(email: self.email.text!, username: (self.username.text?.replacingOccurrences(of: " ", with: ""))!, pwd: self.password.text!, instance: self) { _ in
			self.hideLoadingOverlay()
		}
	}
	
}
