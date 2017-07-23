//
//  FuelCellViewModel.swift
//  FuelBuddy
//
//  Created by Mac user on 18.07.17.
//  Copyright © 2017 pavlyukova.ekaterina. All rights reserved.
//

import Foundation
import CoreLocation
import GoogleMaps


class FuelCellViewModel {
	
	private let fuel: Fuel
	
	var address: String?
	
	var didUpdate:(()->())?
	
	var currentLocation: CLLocationCoordinate2D?
	var fuelCoordinate: CLLocationCoordinate2D {
		return fuel.coordinate
	}
	
	init(fuel: Fuel, currentLocation: CLLocationCoordinate2D? = nil) {
		self.fuel = fuel
		self.currentLocation = currentLocation
		//findAddress()
	}
	func findAddress(completion:@escaping ()->()) {
		let geocoder = GMSGeocoder()
		let coordinate = CLLocationCoordinate2D(latitude: fuel.latitude, longitude: fuel.longitude)
		geocoder.reverseGeocodeCoordinate(coordinate) {[weak self] (response, error) in
			DispatchQueue.main.async {
				self?.address = response?.firstResult()?.lines?.first
				completion()
			//	self?.didUpdate?()

			}
		}

	}
	
	func nameTitle() -> String {
		return fuel.name
	}
	
	func distance() -> String {
		guard let currentLocation = currentLocation else {
			return ""
		}
		let distance = CLLocation.distance(from: currentLocation, to: fuel.coordinate) / 1000
		let strDistance = String(format:"%.1f km", distance)
		return strDistance
	}
	
	func logoName() -> String {
		return fuel.imageName
	}
	
	func timeUpdated() -> String {
		
		return fuel.lastUpdated.timeAgoSinceNow()
				
	}
	
	func addressString()-> String {
		return address ?? ""
		
	}
	
	func priceString()-> String {
		return String(describing: fuel.price) + "₽"
	}
	
	
	
	
	
}
