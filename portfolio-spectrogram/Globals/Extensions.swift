//
//  Extensions.swift
//  spectrogram
//
//  Created by Sean Lim on 27/11/17.
//  Copyright © 2017 Covve. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
	
	func roundify(_ value: CGFloat) {
		self.clipsToBounds = true
		self.layer.cornerRadius = value
	}
	
	func addShadow() {
		self.layer.shadowOpacity = 0.6
		self.layer.shadowRadius = 15.0
		self.layer.shadowOffset = CGSize(width: 1, height: -1)
	}
	
	func addParallaxToView(amount: Int) {
		let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
		horizontal.minimumRelativeValue = -amount
		horizontal.maximumRelativeValue = amount
		
		let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
		vertical.minimumRelativeValue = -amount
		vertical.maximumRelativeValue = amount
		
		let group = UIMotionEffectGroup()
		group.motionEffects = [horizontal, vertical]
		self.addMotionEffect(group)
	}
	
	func interactAnimation() {
		UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
			self.backgroundColor = appGreen
		}) { _ in
			UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
				self.backgroundColor = appBlack
			}, completion: { _ in
				//
			})
		}
	}
	
	func animateSucceed() {
		UIView.animate(withDuration: 0.2, delay: 0, options: .autoreverse, animations: {
			self.backgroundColor = appGreen
		}, completion: { _ in
			self.backgroundColor = .black
			UIView.animate(withDuration: 0.3, delay: 0, options: .autoreverse, animations: {
				self.backgroundColor = appGreen
			}, completion: { _ in
				self.backgroundColor = appBlack
			})
		})
	}
	
	func animateFailure() {
		UIView.animate(withDuration: 0.2, delay: 0, options: .autoreverse, animations: {
			self.backgroundColor = appRed
		}, completion: { _ in
			self.backgroundColor = .black
			UIView.animate(withDuration: 0.3, delay: 0, options: .autoreverse, animations: {
				self.backgroundColor = appRed
			}, completion: { _ in
				self.backgroundColor = appBlack
			})
		})
	}

}

extension Date {
	
	
	func formatDay() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		return dateFormatter.string(from: self)	}
	
	func stringFromDate() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
		return dateFormatter.string(from: self)
	}
	
	/// Returns the amount of years from another date
	func years(from date: Date) -> Int {
		return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
	}
	/// Returns the amount of months from another date
	func months(from date: Date) -> Int {
		return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
	}
	/// Returns the amount of weeks from another date
	func weeks(from date: Date) -> Int {
		return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
	}
	/// Returns the amount of days from another date
	func days(from date: Date) -> Int {
		return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
	}
	/// Returns the amount of hours from another date
	func hours(from date: Date) -> Int {
		return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
	}
	/// Returns the amount of minutes from another date
	func minutes(from date: Date) -> Int {
		return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
	}
	/// Returns the amount of seconds from another date
	func seconds(from date: Date) -> Int {
		return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
	}
	/// Returns the a custom time interval description from another date
	func offset(from date: Date) -> String {
		if years(from: date)   > 0 { return "\(years(from: date)) years"   }
		if months(from: date)  > 0 { return "\(months(from: date)) months"  }
		if weeks(from: date)   > 0 { return "\(weeks(from: date)) weeks"   }
		if days(from: date)    > 0 { return "\(days(from: date)) days"    }
		if hours(from: date)   > 0 { return "\(hours(from: date)) hours"   }
		if minutes(from: date) > 0 { return "\(minutes(from: date)) minutes" }
		if seconds(from: date) > 0 { return "\(seconds(from: date)) seconds" }
		if seconds(from: date) == 0 {return "Now"}
		return ""
	}
}

extension String {
	func dateFromString() -> Date {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
		return dateFormatter.date(from: self)!
	}
}

