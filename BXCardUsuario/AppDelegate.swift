//
//  AppDelegate.swift
//  VittaCardUsuario
//
//  Created by Daive Simões on 20/02/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import UIKit
import UserNotifications
import IQKeyboardManagerSwift
import GoogleMaps
import Firebase
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // MARK: - IQKeyboarManager
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Ok"
        
        // MARK: - Goolge
        GMSServices.provideAPIKey(Constants.APIS._GOOGLE_MAPS_API_KEY)
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions,completionHandler: { _, _ in
        })
        application.registerForRemoteNotifications()
        
        Messaging.messaging().delegate = self
        
        // Network Reachability
        ConnectivityService.instance.startConnectionListener()
        
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        ConnectivityService.instance.startConnectionListener()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        ConnectivityService.instance.stopConnectionListener()
    }

    // MARK: - Push Notifications
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Registered for remote notification with device token \(deviceToken)")
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Error on registering for remote notification: \(error.localizedDescription)")
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        AppContext.shared.fcmToken = fcmToken ?? ""
    }
    
}

