//
//  MarkerBackground.swift
//  FuelBuddy
//
//  Created by Mac user on 17.07.17.
//  Copyright © 2017 pavlyukova.ekaterina. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class MarkerBackground: UIView {
	
	override func draw(_ rect: CGRect) {
		let rectanglePath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: rect.width, height: 30), cornerRadius: 5)
		ColorPallete.markerBackground.setFill()
		rectanglePath.fill()
		
		let whiteRectanglePath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 30, height: 30), byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: 5, height: 5))
		UIColor.white.setFill()
		whiteRectanglePath.fill()
		
		let bezierPath = UIBezierPath()
		bezierPath.move(to: CGPoint(x: 40, y: 30))
		bezierPath.addLine(to: CGPoint(x: 44, y: 36))
		bezierPath.addLine(to: CGPoint(x: 48, y: 30))
		ColorPallete.markerBackground.setFill()
		bezierPath.fill()
		
		layer.shadowColor = UIColor.black.cgColor
		layer.shadowRadius = 2
		layer.shadowOffset = CGSize(width: 3, height: 2)
		layer.masksToBounds = false
		layer.shadowOpacity = 0.5
		
	}
	
}
