//
//  CustomSegmentedControl.swift
//  FuelBuddy
//
//  Created by Mac user on 17.07.17.
//  Copyright © 2017 pavlyukova.ekaterina. All rights reserved.
//

import UIKit

@IBDesignable
class CustomSegmentedControl: UIControl {
	var pointerImageView: UIImageView!
	var buttons: [UIButton] = []
	var selectedIndex: Int = 0 {
		didSet{
			guard selectedIndex < buttons.count, selectedIndex >= 0 else {
				selectedIndex = min(buttons.count-1, selectedIndex)
				return
			}
			setSelectedButtonAt(selectedIndex)
			sendActions(for: .valueChanged)
		}
	}
	
	@IBInspectable
	var commaSeparatedButtonTitles: String = "" {
		didSet{
			updateView()
		}
	}
	
	@IBInspectable
	var pointerImage: UIImage? {
		didSet{
			updateView()
		}
	}
	
	@IBInspectable
	var normalTitleColor: UIColor = ColorPallete.segmentNormalTitle {
		didSet{
			updateView()
		}
	}
	
	@IBInspectable
	var selectedTitleColor: UIColor = ColorPallete.segmentSelectedTitle {
		didSet{
			updateView()
		}
	}
	
	@IBInspectable
	var mainColor: UIColor = ColorPallete.segmentBackground {
		didSet{
			updateView()
		}
	}
	
	func setSelectedButtonAt(_ index: Int) {
		guard index >= 0 && index < buttons.count else { return }
		buttons.forEach{$0.setTitleColor(normalTitleColor, for: .normal)}
		let button = buttons[index]
		button.setTitleColor(selectedTitleColor, for: .normal)
		
		UIView.animate(withDuration: 0.4, animations: {
			self.pointerImageView.center.x = button.center.x
		})
		
	}
	
	func buttonTapped(sender: UIButton) {
		for (index,btn) in buttons.enumerated() {
			if btn == sender {
				selectedIndex = index
			}
		}
	}
	
	func updateView() {
		
		backgroundColor = mainColor
		buttons.removeAll()
		subviews.forEach { $0.removeFromSuperview() }
		let buttonTitles = commaSeparatedButtonTitles.components(separatedBy: ",")
		let screen = UIScreen.main.bounds
		let width: CGFloat = screen.width / CGFloat(buttonTitles.count)
		var originX: CGFloat = 0.0

		for title in buttonTitles {
			let button = createButton(title, originX: originX, width: width)
			buttons.append(button)
			addSubview(button)
			originX += width
		}
		
		createSegmentPointer()
		setSelectedButtonAt(selectedIndex)
		
		
	}
	
	private func createSegmentPointer() {
		pointerImageView = UIImageView(image: pointerImage)
		pointerImageView.contentMode = .scaleAspectFill
		addSubview(pointerImageView)
		
		pointerImageView.frame.origin.y = frame.height
		pointerImageView.center.x = buttons[selectedIndex].center.x
	}
	
	private func createButton(_ title: String, originX: CGFloat, width: CGFloat) -> UIButton {
		
		let button = UIButton(frame: CGRect(x: originX, y: 0, width: width, height: bounds.height))
		button.titleLabel?.font = Font(type: .installed(.helveticaNeueCyrRoman), size: .standard(.h4)).instance
		button.setTitle(title, for: .normal)
		button.setTitleColor(normalTitleColor, for: .normal)
		button.titleLabel?.adjustsFontSizeToFitWidth = true
		button.titleLabel?.textAlignment = .center
		button.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
		return button
	}

}
