//
//  SearchTextField.swift
//  FuelBuddy
//
//  Created by Mac user on 17.07.17.
//  Copyright © 2017 pavlyukova.ekaterina. All rights reserved.
//

import UIKit
protocol SearchTextFieldDelegate: class {
	func searchDidTapped(_ string: String)
}

@IBDesignable
class SearchTextField: UITextField {
	
	let padding: CGFloat = 8.0
	weak var searchTextFieldDelegate: SearchTextFieldDelegate?
	@IBInspectable
	var leftImage: UIImage? {
		didSet{
			updateView()
		}
	}
	
	@IBInspectable
	var rightImage: UIImage? {
		didSet{
			updateView()
		}
	}
	
	@IBInspectable
	var cornerRadius: CGFloat = 0.0 {
		didSet{
			layer.cornerRadius = cornerRadius
		}
	}
	
	@IBInspectable
	var borderColor: UIColor = .clear {
		didSet{
			layer.borderColor = borderColor.cgColor
			layer.borderWidth = 1
		}
	}
	
	
	func updateView() {
		
		rightViewMode = rightImage != nil ? .always : .never
		leftViewMode  = leftImage  != nil ? .always : .never
		
		if let leftImage = leftImage {
			leftView = setup(leftImage)
		}
		
		if let rightImage = rightImage {
			rightView = setupSearchButton(rightImage)
		}
		
		let placeholderFont = Font(type: .installed(.helveticaNeueCyrLightItalic), size: .standard(.h3)).instance
		
		attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes:[NSFontAttributeName: placeholderFont])
	}
	
	private func setupSearchButton(_ image: UIImage) -> UIButton {
		let button = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
		button.setImage(image, for: .normal)
		button.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
		return button

	}
	
	private func setup(_ image: UIImage) -> UIImageView {
		let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
		imageView.image = image
		imageView.contentMode = .scaleAspectFit
		return imageView

	}
	
	func searchButtonTapped() {
		guard let text = text else {
			return
		}
		searchTextFieldDelegate?.searchDidTapped(text)
	}
	
	// placeholder position
	override func textRect(forBounds bounds: CGRect) -> CGRect {
		var textRect = super.textRect(forBounds: bounds)
		textRect.origin.x += padding
		return textRect
	}
	
	// text position
	override func editingRect(forBounds bounds: CGRect) -> CGRect {
		var textRect = super.editingRect(forBounds: bounds)
		textRect.origin.x += padding
		return textRect
	}
	
	override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
		var textRect = super.leftViewRect(forBounds: bounds)
		textRect.origin.x += padding
		return textRect
	}
	
	override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
		var textRect = super.rightViewRect(forBounds: bounds)
		textRect.origin.x -= padding
		return textRect
	}
	
	
}
