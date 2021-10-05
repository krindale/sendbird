//
//  AppDelegate.swift
//  Sendbird
//
//  Created by 이해상 on 2021/09/27.
//

import UIKit

//@main
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = self.window ?? UIWindow()
        self.window?.backgroundColor = UIColor.white
        
        self.window?.rootViewController = UINavigationController(rootViewController: SearchViewController())
        self.window?.makeKeyAndVisible()
        return true
    }

}


extension UIApplication {
    
    var topViewController: UIViewController? {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }

        return nil
    }
    
}
