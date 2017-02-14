//
//  WirkTabBarController.swift
//  wirk
//
//  Created by Edward on 2/10/17.
//  Copyright © 2017 Edward. All rights reserved.
//

import UIKit

class WirkTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        // Create the Views that we want in our TabBar
        let customersView = CustomerController()
        let customersNav = UINavigationController(rootViewController: customersView)
        customersNav.tabBarItem.title = "Customers"
        customersNav.tabBarItem.image = UIImage(named: "customer")
        
        let jobView = UIViewController()
        let jobNav = UINavigationController(rootViewController: jobView)
        jobNav.tabBarItem.title = "Jobs"
        jobNav.tabBarItem.image = UIImage(named: "job")
        
        let emailView = UIViewController()
        let emailNav = UINavigationController(rootViewController: emailView)
        emailNav.tabBarItem.title = "Email"
        emailNav.tabBarItem.image = UIImage(named: "email")
        
        let settingsView = SettingsController()
        let settingsNav = UINavigationController(rootViewController: settingsView)
        settingsNav.tabBarItem.title = "Settings"
        settingsNav.tabBarItem.image = UIImage(named: "settings")
        
        tabBar.barTintColor = UIColor(colorType: .navbar)
        tabBar.unselectedItemTintColor = UIColor(colorType: .background)
        tabBar.tintColor = UIColor(colorType: .button)
        viewControllers = [customersNav, jobNav, emailNav, settingsNav]
    }
    
}
