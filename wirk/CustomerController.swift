//
//  CustomerController.swift
//  wirk
//
//  Created by Edward on 2/11/17.
//  Copyright © 2017 Edward. All rights reserved.
//

import UIKit

class CustomerController: UICollectionViewController {
    
    // MARK: Properties
    lazy var addCustomerButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(handleAddCustomerTapped))
        return button
    }()
    
    func handleAddCustomerTapped() {
        let cutomerRegistrationController = CustomerRegistrationController(collectionViewLayout: UICollectionViewFlowLayout())
        let navController = UINavigationController(rootViewController: cutomerRegistrationController)
        present(navController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor(colorType: .background)
        
        navigationItem.title = "Customers"
        navigationItem.rightBarButtonItem = addCustomerButton
    }
    
}
