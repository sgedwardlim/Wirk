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
    var password: String?
    
    init(withSnapshot snapshot: FIRDataSnapshot) {
        let dict = snapshot.value as? [String: Any]
        
        self.name = dict?["name"] as? String
        self.email = dict?["email"] as? String
    }
    
    init(name: String?, password: String?, email: String?) {
        self.name = name
        self.password = password
        self.email = email
    }
}
