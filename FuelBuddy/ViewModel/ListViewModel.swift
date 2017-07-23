//
//  ListViewModel.swift
//  FuelBuddy
//
//  Created by Mac user on 21.07.17.
//  Copyright © 2017 pavlyukova.ekaterina. All rights reserved.
//


import Foundation
import CoreLocation

class ListViewModel<T : ListModel> {
	let model : T
	
	init(model : T) {
		self.model = model
	}
	
	func count() -> Int {
		return model.all().count
	}
	
	func item(ofIndex index: Int) -> T.Model? {
		return model.one(at : index)
	}
	
	var didUpdate:(()->())?
	
	var currentLocation: CLLocationCoordinate2D?  {
		didSet {
			didUpdate?()

		}
	}
	
}

extension ListViewModel {

	func sort(parameter: Sort) {
		model.sort(parameter: parameter)
		didUpdate?()
	}

}


