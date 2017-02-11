//
//  SettingsController.swift
//  wirk
//
//  Created by Edward on 2/10/17.
//  Copyright © 2017 Edward. All rights reserved.
//

import UIKit

class SettingsController: UIViewController {
    
    // MARK: Properties
    lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Logout", for: .normal)
        button.titleLabel?.textColor = .lightGray
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        return button
    }()
    
    func handleLogout() {
        System.sharedInstance.logoutUser()
        let loginRegisterController = LoginRegisterController()
        present(loginRegisterController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(logoutButton)
        
        logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        logoutButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        logoutButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
}

