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
        dismiss(animated: true, completion: nil)
    }
    
    func handleSave() {
        let first = customerHeaderCell?.firstNameField.text
        let middle = customerHeaderCell?.middleNameField.text
        let last = customerHeaderCell?.lastNameField.text
        let location = customerHeaderCell?.locationField.text
        let phone = customerHeaderCell?.phoneField.text
        let email = customerHeaderCell?.emailField.text
        customer = Customer(first, middle: middle, last: last, location: location, phone: phone, email: email)
        System.sharedInstance.uploadToDatabase(with: customer!)
        dismiss(animated: true, completion: nil)
    }
}

extension CustomerHeaderCell {
    
    func handleAddJob() {
        print("New job added")
    }
}
