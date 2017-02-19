//
//  Job.swift
//  wirk
//
//  Created by Edward on 2/14/17.
//  Copyright © 2017 Edward. All rights reserved.
//

import UIKit
import Firebase

class Job {
    // MARK: Properties
    var key: String?
    var ref: FIRDatabaseReference?
    var customerKey: String?
    
    var jobType: String?
    var jobDescription: String?
    
    var beforeImageKey: String?
    var beforeImageUrl: String?
    var beforeImage: UIImage?
    
    var afterImageKey: String?
    var afterImageUrl: String?
    var afterImage: UIImage?
    
//    init(_ jobType: String?, jobDescription: String?, beforeImage: UIImage?, afterImage: UIImage?) {
//        self.jobType = jobType
//        self.jobDescription = jobDescription
//        self.beforeImage = beforeImage
//        self.beforeImageKey = NSUUID().uuidString
//        self.afterImage = afterImage
//        self.afterImageKey = NSUUID().uuidString
//    }
    
    init(withCustomerKey customerKey: String?) {
        guard let key = customerKey else { return }
        self.customerKey = key
        self.beforeImageKey = NSUUID().uuidString
        self.afterImageKey = NSUUID().uuidString
    }
    
    init(withSnapshot snapshot: FIRDataSnapshot, belongsTo customerKey: String) {
        ref = snapshot.ref
        key = snapshot.key
        
        let dict = snapshot.value as? [String: Any]
        
        self.jobType = dict?["jobType"] as? String
        self.jobDescription = dict?["jobDescription"] as? String
        self.beforeImageKey = dict?["beforeImageKey"] as? String
        self.beforeImageUrl = dict?["beforeImageUrl"] as? String
        self.afterImageKey = dict?["afterImageKey"] as? String
        self.afterImageUrl = dict?["afterImageUrl"] as? String
        self.customerKey = customerKey
    }
    
}
