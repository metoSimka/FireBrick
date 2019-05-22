//
//  AppDelegate.swift
//  FireBrick
//
//  Created by metoSimka on 16/05/2019.
//  Copyright © 2019 metoSimka. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import IQKeyboardManager
import SwiftEntryKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    var window: UIWindow?
  
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().keyboardDistanceFromTextField = 30
        
        FirebaseApp.configure()
        setupEntryKit()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
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
    
    func setupEntryKit() {
        var attributes = EKAttributes.centerFloat
        attributes.entryBackground = .color(color: UIColor(white: 0, alpha: 0))
        attributes.screenBackground = .color(color: UIColor(white: 0.1, alpha: 0.4))
        attributes.entranceAnimation = .init(
            translate: .init(duration: 0.4, anchorPosition: .bottom, spring: .init(damping: 1, initialVelocity: 0)),
            scale: .init(from: 1, to: 1, duration: 0.4),
            fade: .init(from: 0.6, to: 1, duration: 0.2))
        attributes.exitAnimation = .init(
            translate: .init(duration: 0.4, anchorPosition: .bottom, spring: .init(damping: 1, initialVelocity: 0)),
            scale: .init(from: 1, to: 1, duration: 0.4),
            fade: .init(from: 0.6, to: 1, duration: 0.2))
        attributes.displayDuration = .infinity
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.2, radius: 10, offset: .init(width: 0, height: 7)))
        attributes.roundCorners = .all(radius: 8)
        attributes.entryInteraction = .absorbTouches
        attributes.screenInteraction = .dismiss
        attributes.scroll = .disabled
        EKAttributes.default = attributes
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard error == nil else {
            print("\(error.localizedDescription)")
            return
        }
        
        guard let authentication = user.authentication else {
            return
        }
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            guard error == nil else {
                print(error ?? "authentication error", " did happen")
                return
            }
            NotificationCenter.default.post(name: .googleSignedIn, object: nil)
        }
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: [:])
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("DISCONNECTED")
    }
}

extension Notification.Name {
    static let googleSignedIn = Notification.Name("googleSignedIn")
}
