//
//  Fuel.swift
//  FuelBuddy
//
//  Created by Mac user on 17.07.17.
//  Copyright © 2017 pavlyukova.ekaterina. All rights reserved.
//

import Foundation
import CoreLocation

struct Fuel {
	let name: String
	let latitude: Double
	let longitude: Double
	let price: Double
	let lastUpdated: Date
	let imageName: String
	
	
	static func loadBase() -> [Fuel] {
		
		let shell1 = 	Fuel(name: "Shell", latitude: 49.976803, longitude: 36.189695, price: 20.0, lastUpdated: Date().addingTimeInterval(-30*60), imageName: "shall")
		let shell2 = Fuel(name: "Shell", latitude: 49.968553, longitude: 36.243026, price: 25.0, lastUpdated: Date().addingTimeInterval(-60*60*60), imageName: "gazprom")
		let gasprom1 = Fuel(name: "Gasprom", latitude: 49.963306, longitude: 36.258132, price: 22.0, lastUpdated: Date().addingTimeInterval(-120*60*60), imageName: "gazprom")
		let gasprom2 = Fuel(name: "Gasprom", latitude: 49.998990, longitude: 36.205947, price: 22.0, lastUpdated: Date().addingTimeInterval(-180*60*60), imageName: "gazprom")
		
		return [shell1, shell2, gasprom1, gasprom2]
	}
	
}

extension Fuel {
	var coordinate: CLLocationCoordinate2D {
		return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
	}
}
