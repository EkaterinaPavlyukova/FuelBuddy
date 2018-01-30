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
    let appKey = "AIzaSyDoc8lw2mFtvOPk_SLQ3n8piHc_DwKcTUw"

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        print("New line")
		GMSServices.provideAPIKey(appKey)
		GMSPlacesClient.provideAPIKey(appKey)

		return true
	}

}

