//
//  GradientView.swift
//  FuelBuddy
//
//  Created by Mac user on 17.07.17.
//  Copyright © 2017 pavlyukova.ekaterina. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView: UIView {
	
	@IBInspectable var FirstColor:UIColor = UIColor.clear {
		didSet{
			updateView()
		}
	}
	
	@IBInspectable var SecondColor:UIColor = UIColor.clear {
		didSet{
			updateView()
		}
	}
	
	override class var layerClass: AnyClass{
		get{
			return CAGradientLayer.self
		}
	}
	
	func updateView(){
		let layer = self.layer as! CAGradientLayer
		layer.colors = [FirstColor.cgColor, SecondColor.cgColor]
		layer.locations = [0.7]
	}
	
	
}
