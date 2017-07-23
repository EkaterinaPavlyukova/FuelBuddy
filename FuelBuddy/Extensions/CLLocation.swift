//
//  CLLocation.swift
//  FuelBuddy
//
//  Created by Mac user on 22.07.17.
//  Copyright © 2017 pavlyukova.ekaterina. All rights reserved.
//

import Foundation
import CoreLocation

extension CLLocation {
	// In meteres
	class func distance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
		let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
		let to = CLLocation(latitude: to.latitude, longitude: to.longitude)
		return from.distance(from: to)
	}
}
