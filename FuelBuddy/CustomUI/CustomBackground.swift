//
//  CustomBackground.swift
//  FuelBuddy
//
//  Created by Mac user on 17.07.17.
//  Copyright © 2017 pavlyukova.ekaterina. All rights reserved.
import UIKit


@IBDesignable
class CustomBackground: UIView {
	
	override func draw(_ rect: CGRect) {
				let centerX = rect.size.width/2
		let width:CGFloat = 120
		let rectangle = CGRect(x: 0, y: 20, width: rect.width, height: 46)

		let mainRect = UIBezierPath(rect: rectangle)
		mainRect.close()
		UIColor.white.setFill()
		mainRect.fill()

		let rectRound = CGRect(x: centerX - width/2, y: 0, width: width, height: 20)
		let rec = UIBezierPath(roundedRect: rectRound, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 5, height: 5))
		rec.close()
		UIColor.white.setFill()
		rec.fill()
		
		layer.shadowColor = ColorPallete.shadowColor.cgColor
		layer.shadowOpacity = 0.3
		layer.shadowRadius = 4.0

	}
	
}

