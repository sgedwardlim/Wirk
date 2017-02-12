//
//  CustomerRegistrationController+Handler.swift
//  wirk
//
//  Created by Edward on 2/11/17.
//  Copyright © 2017 Edward. All rights reserved.
//

import UIKit

extension CustomerRegistrationController {
    
    func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func handleSave() {
        print("Saved")
    }
    
    
}

extension CustomerHeaderCell {
    
    func handleAddJob() {
        print("New job added")
    }
}
