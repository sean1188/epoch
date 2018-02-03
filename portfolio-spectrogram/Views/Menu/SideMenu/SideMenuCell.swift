//
//  Cell.swift
//  portfolio-spectrogram
//
//  Created by Sean Lim on 24/1/18.
//  Copyright © 2018 cool. All rights reserved.
//

import Foundation
import UIKit
import QRCode

class SideMenuCell: UITableViewCell {
	
	@IBOutlet var qrcode: UIImageView!
	@IBOutlet var followers: UILabel!
	@IBOutlet var Desc: UILabel!
	
	
	override func awakeFromNib() {
		Desc?.text = "@\(user_name ?? "null") 🙌🏽"
		followers?.text = "Following \(subscribed?.count ?? 0) friends 🔥".uppercased()
		var code = QRCode(user!.uid)!
		code.backgroundColor = CIColor(cgColor: appBlack.cgColor)
		code.color = CIColor(cgColor: appRed.cgColor)
		qrcode?.image = code.image
	}
	
}
