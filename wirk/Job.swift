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
    
    var jobType: String?
    var jobDescription: String?
    var beforeImageUrl: String?
    var beforeImage: UIImage?
    var afterImageUrl: String?
    var afterImage: UIImage?
    
    init(_ jobType: String?, jobDescription: String?, beforeImage: UIImage?, afterImage: UIImage?) {
        self.jobType = jobType
        self.jobDescription = jobDescription
        self.beforeImage = beforeImage
        self.afterImage = afterImage
    }
    
    init(withSnapshot snapshot: FIRDataSnapshot) {
        ref = snapshot.ref
        key = snapshot.key
        
        let dict = snapshot.value as? [String: Any]
        
        self.jobType = dict?["jobType"] as? String
        self.jobDescription = dict?["jobDescription"] as? String
        self.beforeImageUrl = dict?["beforeImageUrl"] as? String
        self.afterImageUrl = dict?["afterImageUrl"] as? String
    }
    
}
