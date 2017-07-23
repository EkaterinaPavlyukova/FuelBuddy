//
//  AppDelegate.swift
//  FuelBuddy
//
//  Created by Mac user on 17.07.17.
//  Copyright © 2017 pavlyukova.ekaterina. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Firebase


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		GMSServices.provideAPIKey("AIzaSyDoc8lw2mFtvOPk_SLQ3n8piHc_DwKcTUw")
		GMSPlacesClient.provideAPIKey("AIzaSyDoc8lw2mFtvOPk_SLQ3n8piHc_DwKcTUw")
		FirebaseApp.configure()
		return true
	}

}

