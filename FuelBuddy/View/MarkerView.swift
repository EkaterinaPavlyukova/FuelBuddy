//
//  MarkerView.swift
//  FuelBuddy
//
//  Created by Mac user on 21.07.17.
//  Copyright © 2017 pavlyukova.ekaterina. All rights reserved.
//

import UIKit

class MarkerView: UIView {
	
	var viewModel: FuelCellViewModel?{
		didSet{
			guard viewModel != nil else { return }
			viewModel?.findAddress(completion: {[weak self] in
				guard let strongSelf = self else {return}
				strongSelf.setup()
			})

		}
	}

   
	@IBOutlet weak var addressLabel: UILabel!
	@IBOutlet weak var priceLabel: UILabel!
	@IBOutlet weak var logoimageView: UIImageView!
	
	
	@IBAction func likeTapped(_ sender: UIButton) {
		
		print("User Liked \(String(describing: viewModel?.nameTitle())) at \(String(describing: viewModel?.addressString()))")
		
	}
	
	
	@IBAction func destinationTapped(_ sender: UIButton) {
		print("destination tapped")
	}
	
	private func setup() {
		addressLabel.text = viewModel!.addressString()
		logoimageView.image = UIImage(named: viewModel!.logoName())
		priceLabel.text = viewModel!.priceString()
		
	}
	
	
	
}
