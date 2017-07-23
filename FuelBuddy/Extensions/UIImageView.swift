//
//  UIImageView.swift
//  FuelBuddy
//
//  Created by Mac user on 22.07.17.
//  Copyright © 2017 pavlyukova.ekaterina. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
	
	func circleWithImage (){
		
		layer.cornerRadius = self.frame.width / 2;
		layer.masksToBounds = true

		UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
		guard let context = UIGraphicsGetCurrentContext() else { return }
		layer.render(in: context)
		let result = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		clipsToBounds = true
		image = result
		
	}
	
}

