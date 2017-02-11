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
        let settingsView = SettingsController()
        let settingsNav = UINavigationController(rootViewController: settingsView)
        settingsNav.tabBarItem.title = "Settings"
        
        viewControllers = [settingsNav]
    }
    
}
