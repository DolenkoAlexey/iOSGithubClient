//
//  AppDelegate.swift
//  iOSAppForGitHub
//
//  Created by Alex Dolenko on 03/09/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import UIKit
import Moya
import MoyaSugar

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let userViewModel = UserViewModel()
        
        let userViewController =
            ((window?.rootViewController as? UITabBarController)?
            .viewControllers?[0] as? UINavigationController)?
            .viewControllers[0] as? UserViewController
        userViewController?.viewModel = userViewModel
        
        return true
    }
}

