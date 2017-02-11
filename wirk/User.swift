//
//  User.swift
//  wirk
//
//  Created by Edward on 2/10/17.
//  Copyright © 2017 Edward. All rights reserved.
//

import Foundation
import Firebase

struct User {
    
    var name: String?
    var email: String?
    
    init(withSnapshot snapshot: FIRDataSnapshot) {
        let dict = snapshot.value as? [String: Any]
        
        self.name = dict?["name"] as? String
        self.email = dict?["email"] as? String
    }
}
