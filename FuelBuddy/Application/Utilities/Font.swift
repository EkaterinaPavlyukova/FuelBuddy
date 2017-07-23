//
//  Font.swift
//  FuelBuddy
//
//  Created by Mac user on 17.07.17.
//  Copyright © 2017 pavlyukova.ekaterina. All rights reserved.
//

import Foundation
import UIKit

struct Font {
	enum FontType {
		case installed(FontName)
		case custom(String)
		case system
		case systemBold
		case systemItatic
	}
	
	enum FontSize {
		case standard(StandardSize)
		case custom(Double)
		var value: Double {
			switch self {
			case .standard(let size):
				return size.rawValue
			case .custom(let customSize):
				return customSize
			}
		}
	}
	
	enum FontName: String {
		case helveticaNeueCyrLight       = "HelveticaNeueCyr-Light"
		case helveticaNeueCyrRoman       = "HelveticaNeueCyr-Roman"
		case helveticaNeueCyrLightItalic = "HelveticaNeueCyr-LightItalic"
	}
	
	enum StandardSize: Double {
		case h1 = 22.0
		case h2 = 20.0
		case h3 = 18.0
		case h4 = 16.0
		case h5 = 14.0
		case h6 = 12.0
		case h7 = 10.0
	}
	
	let type: FontType
	let size: FontSize


}
extension Font {
	var instance: UIFont {
		var instanceFont: UIFont!
		switch type {
		case .custom(let fontName):
			guard let font =  UIFont(name: fontName, size: CGFloat(size.value)) else {
				fatalError("\(fontName) font is not installed, make sure it is added in Info.plist")
			}
			instanceFont = font
		case .installed(let fontName):
			guard let font =  UIFont(name: fontName.rawValue, size: CGFloat(size.value)) else {
				fatalError("\(fontName.rawValue) font is not installed, make sure it is added in Info.plist")
			}
			instanceFont = font
		case .system:
			instanceFont = UIFont.systemFont(ofSize: CGFloat(size.value))
		case .systemBold:
			instanceFont = UIFont.boldSystemFont(ofSize: CGFloat(size.value))
		case .systemItatic:
			instanceFont = UIFont.italicSystemFont(ofSize: CGFloat(size.value))
				}
		return instanceFont
	}
}


