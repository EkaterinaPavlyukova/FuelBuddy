//
//  FuelTableViewCell.swift
//  FuelBuddy
//
//  Created by Mac user on 17.07.17.
//  Copyright © 2017 pavlyukova.ekaterina. All rights reserved.
//

import UIKit

class FuelTableViewCell: UITableViewCell {
	
	var viewModel: FuelCellViewModel! {
		didSet{
			guard viewModel != nil else { return }
			viewModel?.findAddress(completion: {[weak self] in
				guard let strongSelf = self else {return}
				strongSelf.setup()
			})
			
		}
	}

	@IBOutlet weak var costLabel: UILabel!
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var logoImageView: UIImageView!
	@IBOutlet weak var addressLabel: UILabel!
	@IBOutlet weak var distanceLabel: UILabel!
	@IBOutlet weak var nameLabel: UILabel!
	
	@IBAction func diractionTapped(_ sender: UIButton) {
		
		let name = Notification.Name(rawValue: drawNotificationKey)
		NotificationCenter.default.post(name: name, object: nil, userInfo: ["coordinate": viewModel.fuelCoordinate])
	
	}
	
	private func setup() {
		nameLabel.text = viewModel.nameTitle()
		addressLabel.text = viewModel.addressString()
		timeLabel.text = viewModel.timeUpdated()
		logoImageView.image = UIImage(named: viewModel.logoName())
		costLabel.text = viewModel.priceString()
		distanceLabel.text = viewModel.distance()
		
	}
	
	private func configureFonts() {
		nameLabel.font = Font(type: .installed(.helveticaNeueCyrRoman), size: .standard(.h4)).instance
		nameLabel.textColor = ColorPallete.cellTitle
		
		addressLabel.font = Font(type: .installed(.helveticaNeueCyrRoman), size: .standard(.h5)).instance
		addressLabel.textColor = ColorPallete.cellAddress
		
		distanceLabel.font = Font(type: .installed(.helveticaNeueCyrRoman), size: .standard(.h6)).instance
		distanceLabel.textColor = ColorPallete.cellDistance
		
		timeLabel.font = Font(type: .installed(.helveticaNeueCyrLight), size: .standard(.h7)).instance
		timeLabel.textColor = ColorPallete.cellTime
		
		costLabel.font = Font(type: .installed(.helveticaNeueCyrRoman), size: .standard(.h4)).instance
		
		costLabel.textColor = ColorPallete.cellPrice
	
		
	}
	
    override func awakeFromNib() {
        super.awakeFromNib()
		configureFonts()
    }

	
}



