//
//  Base.swift
//  portfolio-spectrogram
//
//  Created by Sean Lim on 31/1/18.
//  Copyright © 2018 cool. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class BaseViewController: UIViewController {
	var loadingOverlay: UIView! = UIView()
	var loadingInd: NVActivityIndicatorView!
	
	override func viewDidLoad() {
		loadingOverlay.backgroundColor = appBlack
		loadingOverlay.alpha = 0.6
		loadingOverlay.frame = self.view.frame
		self.view.addSubview(loadingOverlay)
//		loadingOverlay.isHidden = true
		loadingInd = NVActivityIndicatorView.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
		loadingInd.type = .ballPulse
		loadingInd.center = self.view.center
		loadingInd.startAnimating()
		self.view.addSubview(loadingInd)
	}
}
