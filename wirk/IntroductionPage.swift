//
//  Introduction.swift
//  wirk
//
//  Created by Edward on 3/16/17.
//  Copyright © 2017 Edward. All rights reserved.
//

import UIKit

struct IntroductionPage {
    
    let imageName: String?
    let image: UIImage?
    let description: String?

    init(imageName: String, description: String?) {
        self.imageName = imageName
        self.image = UIImage(named: imageName)
        self.description = description
    }
}
