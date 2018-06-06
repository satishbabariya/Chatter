//
//  AppDelegate.swift
//  Chatter
//
//  Created by Satish on 04/06/18.
//  Copyright © 2018 Satish Babariya. All rights reserved.
//

import Async
import FirebaseAuth
import FirebaseCore
import FirebaseDatabase
import FirebaseFirestore
import FirebaseInstanceID.FIRInstanceID
import FirebaseMessaging
import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setupFirebase()
        authStateChangeListener()
        handlePresence()
        launchUI()
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}

extension AppDelegate {
    
    // For Setting Up Firebase
    fileprivate func setupFirebase() {
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = false
        // Messaging.messaging().delegate = self
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
    }
    
    fileprivate func authStateChangeListener() {
        Auth.auth().addStateDidChangeListener { _, user in
            if user != nil {
                Database.database().goOnline()
                self.subscribe()
                self.loadHomeUI()
            } else {
                Database.database().goOffline()
                self.unsubscribe()
                self.loadAuthUI()
            }
        }
        
    }
    
    /// User Presence System
    ///
    /// By combining disconnect operations with connection state monitoring and server timestamps, you can build a user presence system. In this system, each user stores data at a database location to indicate whether or not a Realtime Database client is online. Clients set this location to true when they come online and a timestamp when they disconnect. This timestamp indicates the last time the given user was online.
    fileprivate func handlePresence() {
        
        Database.database().reference(withPath: ".info/connected").observe(.value, with: { snapshot in
            // only handle connection established (or I've reconnected after a loss of connection)
            guard let connected = snapshot.value as? Bool, connected else { return }
            
            /// Get Current Logged In User
            guard let currentUser = Auth.auth().currentUser else {
                return
            }
            
            // add this device to my connections list
            let connections = ChatRefrences.presence.child(currentUser.uid).child("connections")
            
            // stores the timestamp of my last disconnect (the last time I was seen online)
            let lastOnlineRef = ChatRefrences.presence.child(currentUser.uid).child("lastOnline")
            
            // when this device disconnects, remove it.
            connections.onDisconnectRemoveValue()
            
            // this value could contain info about the device or a timestamp instead of just true
            connections.setValue(true)
            
            // when I disconnect, update the last time I was seen online
            lastOnlineRef.onDisconnectSetValue(ServerValue.timestamp())
            
            // The onDisconnect() call is before the call to set() itself. This is to avoid a race condition
            // where you set the user's presence to true and the client disconnects before the
            // onDisconnect() operation takes effect, leaving a ghost user.
            
        })
    }
}

extension AppDelegate {
    func launchUI() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = .white
        if Auth.auth().currentUser != nil {
            self.loadHomeUI()
        } else {
            self.loadAuthUI()
        }
    }
    
    fileprivate func loadHomeUI() {
        self.window?.rootViewController = TabBarController()
        self.window?.makeKeyAndVisible()
    }
    
    fileprivate func loadAuthUI() {
        self.window?.rootViewController = SplashViewController()
        self.window?.makeKeyAndVisible()
    }
}

// MARK: Notification

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    fileprivate func registerForPushNotifications() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            granted, _ in
            print("Permission granted: \(granted)")
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    
    fileprivate func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            Async.main({
                UIApplication.shared.registerForRemoteNotifications()
            })
        }
    }
    
    /// This method will be called whenever FCM receives a new, default FCM token
    /// You can send this token to your application server to send notifications to this device.
    
    // Faild to Register
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    }
    
    // To obtain the APNs device token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Pass device token
        Messaging.messaging().apnsToken = deviceToken
        if let refreshedToken: String = InstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
            self.subscribe()
        }
    }
    
}

extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        self.subscribe()
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Push Recevice : \(remoteMessage.appData)")
    }
    
    func subscribe() {
        guard let uid: String = Auth.auth().currentUser?.uid else {
            return
        }
        Messaging.messaging().subscribe(toTopic: uid)
    }
    
    func unsubscribe() {
        guard let uid: String = Auth.auth().currentUser?.uid else {
            return
        }
        Messaging.messaging().unsubscribe(fromTopic: uid)
    }
}
