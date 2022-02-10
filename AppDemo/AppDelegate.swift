//
//  AppDelegate.swift
//  AppDemo
//
//  Created by Daniel Bonates on 06/12/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let navStyles = UINavigationBar.appearance()
        navStyles.tintColor = .primary
        navStyles.barTintColor = .primary
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .primary
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        UINavigationBar.appearance().tintColor = .primary
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        self.window = UIWindow(frame: UIScreen.main.bounds)

        let navController = UINavigationController(rootViewController: HomeViewController())
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        return true
    }


}
