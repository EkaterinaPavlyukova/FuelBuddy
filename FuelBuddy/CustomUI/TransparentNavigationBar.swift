//
//  TransparentNavigationBar.swift
//  FuelBuddy
//
//  Created by Ekaterina Pavlyukova on 26.07.17.
//  Copyright © 2017 pavlyukova.ekaterina. All rights reserved.
//

import UIKit
@IBDesignable
class TransparentNavigationBar: UINavigationBar {

	override init(frame: CGRect) {
		super.init(frame: frame)
		updateView()
	}
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		updateView()
	}

	func updateView() {
		setBackgroundImage(UIImage(), for: .default)
		shadowImage = UIImage()
		isTranslucent = true
		barTintColor = UIColor.clear
		backgroundColor = UIColor.clear
		tintColor = UIColor.white
		titleTextAttributes = [NSFontAttributeName: Font(type: .installed(.helveticaNeueCyrRoman), size: .standard(.h1)).instance, NSForegroundColorAttributeName: UIColor.white]
		

	}


}
