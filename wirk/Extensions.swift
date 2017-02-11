//
//  Extensions.swift
//  wirk
//
//  Created by Edward on 2/10/17.
//  Copyright © 2017 Edward. All rights reserved.
//

import UIKit

extension UIColor {
    
    enum ThemeColor: Int {
        case background = 0xF4F7F7
        case tint       = 0xAACFD0
        case button     = 0x5DA0A2
        case navbar     = 0x34495E
    }
    
    convenience init(colorType: ThemeColor) {
        self.init(red:(colorType.rawValue >> 16) & 0xff, green:(colorType.rawValue >> 8) & 0xff, blue:colorType.rawValue & 0xff)
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}
