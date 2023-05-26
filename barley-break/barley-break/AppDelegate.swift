//
//  AppDelegate.swift
//  barley-break
//
//  Created by Андрей Лосюков on 26.05.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window

        window.rootViewController = BarleyBreakViewController()
        window.makeKeyAndVisible()
        return true
    }
}
