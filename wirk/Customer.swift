//
//  Customer.swift
//  wirk
//
//  Created by Edward on 2/10/17.
//  Copyright © 2017 Edward. All rights reserved.
//

import Foundation
import Firebase

struct Customer {
    
    // MARK: Properties
    var first: String?
    var middle: String?
    var last: String?
    var address: String?
    var phone: String?
    var email: String?
    var dateCreated: Int?
    
    init(withSnapshot snapshot: FIRDataSnapshot) {
        let dict = snapshot.value as? [String: Any]
        
        self.first = dict?["first"] as? String
        self.middle = dict?["middle"] as? String
        self.last = dict?["last"] as? String
        self.address = dict?["address"] as? String
        self.phone = dict?["phone"] as? String
        self.email = dict?["email"] as? String
        self.dateCreated = dict?["dateCreated"] as? Int
    }
}
