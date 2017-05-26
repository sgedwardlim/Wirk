//
//  Extensions.swift
//  wirk
//
//  Created by Edward on 2/10/17.
//  Copyright © 2017 Edward. All rights reserved.
//

import UIKit

// Create extension for UIColor to easily customize the apps main colors
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


// MARK: ImageViews
let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func loadImagesUsingCache(urlString: String) {
        
        // Check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        }
        
        // Otherwise fire off a new download request
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                DispatchQueue.main.async {
                    
                    if let downloadedImage = UIImage(data: data!) {
                        imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                        self.image = downloadedImage
                    }
                }
            }).resume()
        }
    }
}

extension UIViewController {
    
    func displayAlert(_ title: String, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alertController.addAction(dismissAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func displayAlertWithYesNoOptions(_ title: String?, message: String?, handleNo: @escaping () -> (), handleYes: @escaping () -> ()) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
         let noAction = UIAlertAction(title: "No", style: .destructive) { (alert) in
            handleNo()
        }
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            handleYes()
        }
        alertController.addAction(noAction)
        alertController.addAction(yesAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func handleLogout() {
        System.sharedInstance.logoutUser()
        let introductionController = IntroductionController()
        present(introductionController, animated: true, completion: nil)
    }
}
