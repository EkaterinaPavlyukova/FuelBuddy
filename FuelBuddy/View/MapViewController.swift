//
//  MapViewController.swift
//  FuelBuddy
//
//  Created by Mac user on 17.07.17.
//  Copyright © 2017 pavlyukova.ekaterina. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import SwiftyJSON
import Firebase



let drawNotificationKey = "com.kate.pavlyukova.drawNotification"
private let embedSegueIdentifier = "ListViewController"
private let shownRowCount = 4
private let oneRowHeight:CGFloat = 60


class MapViewController: UIViewController {
	
	@IBOutlet weak var listHeader: CustomBackground!
	@IBOutlet weak var segmentControl: CustomSegmentedControl!
	@IBOutlet weak var listView: UIView!
	@IBOutlet weak var searchTextField: SearchTextField!
	
	var viewModel : ListViewModel<FuelListModel>?

	var map: GMSMapView?
	var locationManager = CLLocationManager()
	var currentLocation: CLLocationCoordinate2D? {
		didSet{
			setupGoogleMap()
		    segmentControl.selectedIndex = 0
			viewModel?.currentLocation = currentLocation
		}
	}
	
	let drawNotification = Notification.Name(rawValue: drawNotificationKey)

	//MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
		
		initializeTheLocationManager()
		configureGestureRecognizers()
		checkIfUserLoggedIn()
		createObserverForDrawingRoute()
		searchTextField.searchTextFieldDelegate = self
		searchTextField.delegate = self
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == embedSegueIdentifier {
			guard let vc = segue.destination as? ListViewController else {
				fatalError("Couldn't find segue identifier")
			}
			viewModel = ListViewModel<FuelListModel>(model: FuelListModel())
			vc.viewModel = viewModel

			
		}
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
	func checkIfUserLoggedIn() {
		if Auth.auth().currentUser?.uid == nil {
			handleLogOut()
		}else{
			let uid = Auth.auth().currentUser?.uid
			Database.database().reference().child("users").child(uid!).child("photoURL").observe(.value, with: { [weak self] (snapshot) in
					guard let strongSelf = self else { return }
					if let photoURL = URL(string: (snapshot.value as? String)!){
						strongSelf.configureUserIconButton(photoURL: photoURL)
					}
				
			})
		}
	}
	
	func configureUserIconButton(photoURL: URL) {
		URLSession.shared.dataTask(with: photoURL, completionHandler: { (data, response, error) in
			guard error == nil, let data = data else { return }
			
			let image = UIImage(data: data)
			
			DispatchQueue.main.async {
				let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
				button.setImage(image, for: .normal)
				button.imageView?.circleWithImage()
				button.addTarget(self, action: #selector(self.userIconTapped), for: .touchUpInside)
				let barButtonItem = UIBarButtonItem(customView: button)
				self.navigationItem.leftBarButtonItem? = barButtonItem
			}
		}).resume()
		
	}

	func handleLogOut(){
		
		Auth.auth().currentUser?.delete(completion: { (error) in
			guard error != nil else {
				return
			}
			self.navigationController?.popViewController(animated: true)
			
		})

	}
	
	func createObserverForDrawingRoute() {
		NotificationCenter.default.addObserver(self, selector: #selector(drawPath(notification:)), name: drawNotification, object: nil)
	}
	
	//MARK: - Map Configuration
	func initializeTheLocationManager() {
		locationManager.delegate = self
		locationManager.requestWhenInUseAuthorization()
		locationManager.startUpdatingLocation()
				
	}
	
	//MARK: - Gesture Configuration
	private func configureGestureRecognizers(){
		let swipeRight = UISwipeGestureRecognizer(target: self,
		                                          action: #selector(swipeSelector))
		swipeRight.direction = .right
		let swipeLeft = UISwipeGestureRecognizer(target: self,
		                                         action: #selector(swipeSelector))
		swipeLeft.direction = .left
		
		let swipeUp = UISwipeGestureRecognizer(target: self,
		                                          action: #selector(swipeSelector))
		swipeUp.direction = .up
		
		let swipeDown = UISwipeGestureRecognizer(target: self,
		                                          action: #selector(swipeSelector))
		swipeDown.direction = .down
		
		
		listView.addGestureRecognizer(swipeRight)
		listView.addGestureRecognizer(swipeLeft)
		listView.addGestureRecognizer(swipeUp)
		listView.addGestureRecognizer(swipeDown)

		
	}
	
	func setupGoogleMap() {
		//Setup camera position for map
		let camera = GMSCameraPosition.camera(withLatitude: currentLocation!.latitude,
		                                      longitude: currentLocation!.longitude,
		                                      zoom: 15)
		map = GMSMapView.map(withFrame: view.frame, camera: camera)
		map?.isMyLocationEnabled = true
		map?.delegate = self
		map?.settings.myLocationButton = true
		map?.settings.compassButton = true
		map?.settings.zoomGestures = true
		map?.padding = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
		view.insertSubview(map!, at: 0)
		showFuels()
	}
	
	func showFuels() {
		guard viewModel != nil else {return}
		for i in 0...viewModel!.count()-1 {
			guard let fuel = viewModel!.item(ofIndex: i) else {return}
			createMarker(fuel: fuel)
		}
	}
	
	func createMarker(fuel:Fuel){
		let marker = GMSMarker(position: fuel.coordinate)
		let iconView = Bundle.main.loadNibNamed("MarkerView", owner: nil, options: nil)?[0] as! MarkerView
		iconView.viewModel = FuelCellViewModel(fuel: fuel)
		marker.iconView = iconView
		marker.map = map
	}
	
	func userIconTapped(_ sender: UIBarButtonItem) {
		let alert = UIAlertController(title: "Вы действительно хотите выйти?", message: "", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Выйти", style: .default, handler: {
			action in
			self.handleLogOut()
		}))
		alert.addAction(UIAlertAction(title: "Отмена", style: .default, handler: nil))
		present(alert, animated: true, completion: nil)
	
	}
	
	//MARK: - Segment value changed
	@IBAction func segmentValueChanged(_ sender: CustomSegmentedControl) {
		switch sender.selectedIndex{
		case 0:
			guard currentLocation != nil else { break }
			viewModel?.sort(parameter: .distance(currentLocation!))
			//sortDelegate?.sortWith(.distance(currentLocation!))
		case 1: viewModel?.sort(parameter: .cost)
		default:break
		}
		
	}
	
	//MARK: - Swipe configuration
	func swipeSelector(_ sender: UISwipeGestureRecognizer) {
		switch sender.direction {
		case UISwipeGestureRecognizerDirection.left: segmentControl.selectedIndex += 1
		case UISwipeGestureRecognizerDirection.right:
			if segmentControl.selectedIndex > 0 {
				segmentControl.selectedIndex -= 1
			}
		case UISwipeGestureRecognizerDirection.up:

			let maxHeaderOriginY = view.frame.height - oneRowHeight * CGFloat(shownRowCount) - listHeader.frame.height

			UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 5, options: [], animations: {
				self.listView.frame.origin.y = maxHeaderOriginY
			}, completion: nil)
			
		case UISwipeGestureRecognizerDirection.down:
			let minHeaderOriginY = view.frame.height - listHeader.frame.height - oneRowHeight
			UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
				self.listView.frame.origin.y = minHeaderOriginY
			}, completion: nil)
		default: break
		}
		print(sender.direction)
	}

}

extension MapViewController: SearchTextFieldDelegate {
	
	func locateWithLongitude(_ lon: Double, andLatitude lat: Double, andTitle title: String) {
		
			let position = CLLocationCoordinate2DMake(lat, lon)
			let marker = GMSMarker(position: position)
			
			let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: 15)
			map?.camera = camera
			marker.title = title
			marker.map = map
		
	}
	
	func searchDidTapped(_ string: String) {
		searchTextField.resignFirstResponder()
		
		let urlpath = "https://maps.googleapis.com/maps/api/geocode/json?address=\(string)&sensor=false".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
		
		let url = URL(string: urlpath!)
		URLSession.shared.dataTask(with: url!) { [weak self] (data, _, error) in
			guard let strongSelf = self else {return}
			guard let data = data, error == nil else { return }
			let json = JSON(data: data)
			let location = json["results"][0]["geometry"]["location"].dictionary
			guard let lat = location?["lat"]?.double,
				let lng = location?["lng"]?.double else { return }
			
				DispatchQueue.main.async {
					strongSelf.locateWithLongitude(lng, andLatitude: lat, andTitle: string)
				}
			}.resume()
		
		
	}
	
	func drawPath(notification: Notification) {
		
		guard currentLocation != nil else { return }
		
		let origin = String(describing:currentLocation!.latitude) + "," + String(describing:currentLocation!.longitude)
		
		let to = notification.userInfo?["coordinate"] as! CLLocationCoordinate2D
		
		let destination = String(describing:to.latitude) + "," + String(describing:to.longitude)
			let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&sensor=false"
		
			URLSession.shared.dataTask(with: URL(string: url)!) {[weak self] (data, response, error) in
				guard let strongSelf = self else {return}

				guard let data = data, error == nil else { return }
				let json = JSON(data: data)
				let routes = json["routes"].arrayValue
				
				DispatchQueue.main.async {
					for route in routes
					{
						let routeOverviewPolyline = route["overview_polyline"].dictionary
						let points = routeOverviewPolyline?["points"]?.stringValue
						let path = GMSPath(fromEncodedPath: points!)
						let polyline = GMSPolyline(path: path)
						polyline.strokeColor = .red
						polyline.strokeWidth = 4
						polyline.map = strongSelf.map
					}
				}
				
			}.resume()

		}
}
extension MapViewController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}
extension MapViewController: CLLocationManagerDelegate {
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
		debugPrint(error.localizedDescription)
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		
		//Get current location
		if currentLocation == nil {
			guard let currentLocation = locations.last?.coordinate else {return}
			self.currentLocation = currentLocation
			locationManager.stopUpdatingLocation()			
		}
		
	}
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		switch status {
		case .notDetermined:
			manager.requestAlwaysAuthorization()
			break
		case .authorizedWhenInUse:
			manager.startUpdatingLocation()
			map?.isMyLocationEnabled = true
			break
		case .authorizedAlways:
			manager.startUpdatingLocation()
			break
		case .restricted:
			// restricted by e.g. parental controls. User can't enable Location Services
			break
		case .denied:
			
			// user denied your app access to Location Services, but can grant access from Settings.app
			break
		}
	}
	
}

extension MapViewController: GMSMapViewDelegate {
	// MARK: - GMSMapViewDelegate
	
	func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
		map?.isMyLocationEnabled = true
	}
	
	func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
		map?.isMyLocationEnabled = true
		
		if (gesture) {
			mapView.selectedMarker = nil
		}
	}
	
	func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
		map?.isMyLocationEnabled = true
		return false
	}
	
	func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
		map?.isMyLocationEnabled = true
		map?.selectedMarker = nil
		return false
	}
	
}

