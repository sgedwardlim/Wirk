//
//  Customer.swift
//  wirk
//
//  Created by Edward on 2/10/17.
//  Copyright © 2017 Edward. All rights reserved.
//

import Foundation
import Firebase

class Customer {
    
    // MARK: Properties
    var first: String
    var middle: String
    var last: String
    var location: String
    var phone: String
    var email: String
    var privacy: Bool
    var timestamp: TimeInterval?
    
    // Convience properties
    var dateCreated: Date?
    var ref: FIRDatabaseReference?
    var key: String?
    
    init(_ first: String?, middle: String?, last: String?, location: String?, phone: String?, email: String?, privacy: Bool?) {
        self.first = first ?? ""
        self.middle = middle ?? ""
        self.last = last ?? ""
        self.location = location ?? ""
        self.phone = phone ?? ""
        self.email = email ?? ""
        self.privacy = privacy!
        // value of customer timestamp is created in the System class
    }
    
    init(withSnapshot snapshot: FIRDataSnapshot) {
        ref = snapshot.ref
        key = snapshot.key
        
        let dict = snapshot.value as? [String: Any]
        
        self.first = dict?["first"] as! String
        self.middle = dict?["middle"] as! String
        self.last = dict?["last"] as! String
        self.location = dict?["location"] as! String
        self.phone = dict?["phone"] as! String
        self.email = dict?["email"] as! String
        self.privacy = dict?["privacy"] as! Bool
        self.timestamp = dict?["timestamp"] as? TimeInterval
        
        guard let date = self.timestamp else { return }
        dateCreated = Date(timeIntervalSince1970: date / 1000)
    }
}
