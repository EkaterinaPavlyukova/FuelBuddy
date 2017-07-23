//
//  UnderlineTextField.swift
//  Sonarsen
//
//  Created by Mac user on 04.02.17.
//  Copyright © 2017 ua.artjoker. All rights reserved.
//

import Foundation
import UIKit


@IBDesignable
class UnderLinedTextField: UITextField {
    
    
	@IBInspectable var lineColor: UIColor = .lightGray {
        didSet { useUnderline() }
    }
    
    @IBInspectable var borderWidth: CGFloat = 1 {
        didSet { useUnderline() }
    }
    
	override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 8, dy: 7)
        
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		useUnderline()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		useUnderline()
	}
        
    func useUnderline() {
        font = Font(type: .installed(.helveticaNeueCyrRoman), size: .standard(.h4)).instance
        let border = CALayer()
        border.borderColor = lineColor.cgColor
        border.frame = CGRect(origin: CGPoint(x: 0, y : frame.size.height - borderWidth), size: CGSize(width: frame.size.width, height: frame.size.height))
        border.borderWidth = borderWidth
		contentVerticalAlignment = .bottom
		layer.addSublayer(border)
        layer.masksToBounds = true
		
		let placeholderFont = Font(type: .installed(.helveticaNeueCyrLightItalic), size: .standard(.h5)).instance
		
		attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes:[NSFontAttributeName: placeholderFont])
    }
    
    
    
    
}
