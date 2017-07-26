//
//  ListViewController.swift
//  FuelBuddy
//
//  Created by Mac user on 17.07.17.
//  Copyright © 2017 pavlyukova.ekaterina. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

enum Sort {
	case cost
	case distance(CLLocationCoordinate2D)
}

class ListViewController: UIViewController {
	
	@IBOutlet weak var listTableView: UITableView!
	var viewModel : ListViewModel<FuelListModel>? {
		didSet {
			viewModel?.didUpdate = {[weak self] in
				self?.listTableView.reloadData()
				
			}
		}
	}
	
	//MARK: - Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		listTableView.register(FuelTableViewCell.self)

	}
	
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel?.count() ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell: FuelTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
		
		if let fuel = viewModel?.item(ofIndex: indexPath.row) {
			cell.viewModel = FuelCellViewModel(fuel: fuel, currentLocation: viewModel?.currentLocation)
		}
		
		return cell
	}
}

