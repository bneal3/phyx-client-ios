//
//  AppDelegate.swift
//  Phyx
//
//  Created by Benjamin Neal on 3/5/19.
//  Copyright © 2019 Phyx, Inc. All rights reserved.
//

import UIKit
import Firebase
import Realm
import RealmSwift
import OneSignal
import Stripe

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        // SQIPInAppPaymentsSDK.squareApplicationID = Constants.Square.APPLICATION_ID
        STPPaymentConfiguration.shared().publishableKey = STRIPE_SUB_KEY
        
        configRealm()
        configOS(launchOptions: launchOptions)
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        //        if let notification = launchOptions?.index(forKey: UIApplicationLaunchOptionsKey.remoteNotification) {
        //            print("App recieved notification from remote %@", notification)
        //        } else {
        //            print("App did not recieve notification");
        //        }
        
        if UserData.shared().isLogged() {
            RealmService.shared.setDefaultRealmForUser(id: UserData.shared().getId())
            
            // FLOW: Get user
//            let locationManager = LocationManager.sharedInstance
//            locationManager.showVerboseMessage = true
//            locationManager.autoUpdate = false
//            locationManager.startUpdatingLocation()
            
            setMainScreen()
        } else {
            setLoginScreen()
        }
        
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.tintColor = UIColor.black
        navigationBarAppearance.barTintColor = UIColor.white
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Avenir Book", size: 18.0)!, NSAttributedString.Key.foregroundColor: UIColor.black]
        
        return true
    }
    
    func configRealm() {
        // FUNCTION: Configure Realm migrations
        let shouldDelete = false
        
        var config = Realm.Configuration.defaultConfiguration
        config.schemaVersion = Constants.REALM_VERSION
        config.migrationBlock = { (migration, oldSchemaVersion) in
            // FLOW: We haven’t migrated anything yet, so oldSchemaVersion == 0
            if (oldSchemaVersion < 1) {
                
            }
        }
        config.deleteRealmIfMigrationNeeded = shouldDelete
        
        // FLOW: Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        
        // FLOW: Now that we've told Realm how to handle the schema change, opening the file will automatically perform the migration
        do {
            _ = try Realm()
        } catch {
            print("Error Initializing Realm from App Delegate")
        }
    }
    
    func configOS(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
        
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: Constants.OS_APP_ID,
                                        handleNotificationAction: nil,
                                        settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.none
        
        // Recommend moving the below line to prompt for push after informing the user about
        //   how your app will use them.
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
    }
    
    func setMainScreen() {
        
//        let mainVC = MainViewController(nibName: "MainViewController", bundle: nil)
//        let nav = UINavigationController(rootViewController: mainVC)
        // nav.isNavigationBarHidden = true
        
        let serviceVC = ContactViewController(nibName: "ContactViewController", bundle: nil)
        serviceVC.title = "Services"
        let nav = UINavigationController(rootViewController: serviceVC)
        
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
    }
    
    func setLoginScreen() {
        
        let authVC = AuthViewController(nibName: "AuthViewController", bundle: nil)
        let navigationVC = UINavigationController(rootViewController: authVC)
        navigationVC.isNavigationBarHidden = true
        
        self.window?.rootViewController = navigationVC
        self.window?.makeKeyAndVisible()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        if(UserData.shared().isLogged()) {
            setBadgeCount(application: application)
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        if(UserData.shared().isLogged()) {
            setBadgeCount(application: application)
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        if(UserData.shared().isLogged()) {
            setBadgeCount(application: application)
        }
    }

    func setBadgeCount(application: UIApplication) {
        var badgeCount = 0
        
        //OneSignal
        application.applicationIconBadgeNumber = badgeCount
    }

}

