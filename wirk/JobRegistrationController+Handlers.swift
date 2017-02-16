//
//  JobRegistrationController+Handlers.swift
//  wirk
//
//  Created by Edward on 2/15/17.
//  Copyright © 2017 Edward. All rights reserved.
//

import UIKit

extension JobRegistrationController {
    
    func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func handleSave() {
        print("Saved")
    }
}
