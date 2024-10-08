//
//  AppDelegate.swift
//  Reciplease
//
//  Created by Thomas Carlier on 26/04/2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if #available(iOS 13.0, *) {
            let appAppearance = UINavigationBarAppearance()
            appAppearance.configureWithOpaqueBackground()
            appAppearance.backgroundColor = UIColor.background
            appAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]

            UINavigationBar.appearance().standardAppearance = appAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = appAppearance
        } else {
            UINavigationBar.appearance().barTintColor = UIColor.brown
            UINavigationBar.appearance().isTranslucent = false
            UINavigationBar.appearance().tintColor = UIColor.white
        }

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

