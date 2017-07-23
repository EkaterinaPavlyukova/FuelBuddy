//
//  FuelListModel.swift
//  FuelBuddy
//
//  Created by Mac user on 22.07.17.
//  Copyright © 2017 pavlyukova.ekaterina. All rights reserved.
//

import Foundation
import CoreLocation

class FuelListModel: ListModel {
	typealias Model = Fuel
	
	var base = Fuel.loadBase()
	
	func all() -> [Fuel] {
		return base
	}
	
	func one(at index: Int)  -> Fuel? {
		if index >= 0 && index < base.count {
			return base[index]
		}
		return nil
	}
	
	func sort(parameter: Sort) {
		switch parameter {
		case .cost: base.sort{ $0.price < $1.price }
		case .distance(let coordinate):
			base.sort{CLLocation.distance(from: coordinate, to: $0.coordinate) < CLLocation.distance(from: coordinate, to: $1.coordinate)}
		}
		
	}
}

