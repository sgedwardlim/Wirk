//
//  SelectedJobs.swift
//  wirk
//
//  Created by Edward on 3/28/17.
//  Copyright © 2017 Edward. All rights reserved.
//

import Foundation

// Singleton for jobs selected by user
class SelectedJobs {
    static let shared = SelectedJobs()
    var jobs = [Job]()
    
    func addCustomersToJobs(completion: @escaping () -> ()) {
        for job in jobs {
            // load all the customer values for the selected job
            System.customerRef.child("\(System.uid!)").child("\(job.customerKey!)").observe(.value, with: { (snapshot) in
                job.customer = Customer(withSnapshot: snapshot)
                completion()
            })
        }
    }
}
