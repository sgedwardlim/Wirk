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
}
