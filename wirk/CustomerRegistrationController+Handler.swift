//
//  CustomerRegistrationController+Handler.swift
//  wirk
//
//  Created by Edward on 2/11/17.
//  Copyright © 2017 Edward. All rights reserved.
//

import UIKit
import Firebase

extension CustomerRegistrationController {
    
    func handleCancel() {
        guard let key = customer?.key else { return }
        guard let uid = System.uid else { return }
        // Check if customer is in FIREBASE Database
        System.customerRef.child(uid).child(key).observe(.value, with: { (snapshot) in
            /*
             User selected the cancel option when user is not saved into FIREBASE
             DATABASE, hence attempt to delete all assocaited jobs on the DATABASE,
             Checks if the snapshot (reference to data in FIREBASE) exist
             */
            if (!snapshot.exists()) {
                // If customer jobs return nil, then no jobs associated, dismiss view
                if let jobs = self.customer?.jobs {
                    // Iterate through all jobs associated with the current customer
                    // and remove them From the FIREBASE DATABASE
                    for job in jobs {
                        job.ref?.removeValue()
                        System.sharedInstance.deleteImageFiles(for: job, customerKey: key)
                    }
                }
            }
        })
        dismiss(animated: true, completion: nil)
    }
    
    func handleSave() {
        let first = customerHeaderCell?.firstNameField.text
        let middle = customerHeaderCell?.middleNameField.text
        let last = customerHeaderCell?.lastNameField.text
        let location = customerHeaderCell?.locationField.text
        let phone = customerHeaderCell?.phoneField.text
        let email = customerHeaderCell?.emailField.text
        let privacy = customerHeaderCell?.privacySwitchControl.isOn
        
        // safely unwraping the existing customer
        if let customer = customer {
            customer.first = first
            customer.middle = middle
            customer.last = last
            customer.location = location
            customer.phone = phone
            customer.email = email
            // implict unwrap because variable can only be on or off, no nil state
            customer.privacy = privacy!
            System.sharedInstance.updateCustomerToDatabase(with: customer)
        }
        dismiss(animated: true, completion: nil)
    }
}

extension CustomerHeaderCell {
    
    func handleAddJob() {
        let view = JobRegistrationController()
        // Create a new job with the customer's key
        view.job = Job(withCustomerKey: customer?.key)
        let nav = UINavigationController(rootViewController: view)
        guard let regController = registrationController else { return }
        regController.present(nav, animated: true, completion: nil)
    }
}





