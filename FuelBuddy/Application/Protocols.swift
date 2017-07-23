//
//  Protocols.swift
//  FuelBuddy
//
//  Created by Mac user on 22.07.17.
//  Copyright © 2017 pavlyukova.ekaterina. All rights reserved.
//

import Foundation

public protocol Model {}

protocol ListModel : Model {
	associatedtype Model = Any
	func all() -> [Model]
	func one(at index: Int) -> Model?
	func sort(parameter: Sort)
}


