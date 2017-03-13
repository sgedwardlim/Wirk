//
//  ReceiptManager.swift
//  wirk
//
//  Created by Edward on 3/10/17.
//  Copyright © 2017 Edward. All rights reserved.
//

import Foundation
import StoreKit

// Every new Xcode project is built in with a DEBUG flag we can use to determine if we're using the app in debug or release
#if DEBUG
let isDebug = true
#else
let isDebug = false
#endif


enum ReceiptValidationiTunesURLS: String {
    
    case sandbox = "https://sandbox.itunes.apple.com/verifyReceipt"
    case production = "https://buy.itunes.apple.com/verifyReceipt"
    
    static var url: URL {
        if isDebug {
            return URL.init(string: self.sandbox.rawValue)!
        } else {
            return URL.init(string: self.production.rawValue)!
        }
    }
}


extension ReceiptManager: SKRequestDelegate {
    
    func requestDidFinish(_ request: SKRequest) {
        // Now if the refresh request is finished then we need to call our startValidating
        // Function again to start the whole process again. But in order to not get stuck in a loop
        // if the receipt never existed we need to add some extra logic
        
        self.startValidatingReceipts()
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Error refreshing receipt ", error.localizedDescription)
    }
}

class ReceiptManager: NSObject {
    
    // This function will be called when we init our ReceiptManager in StoreManger class
    override init() {
        super.init()
        // set refresh receipt to false everytime at beginning of app
        UserDefaults.standard.set(false, forKey: "didRefreshReceipt")
        self.startValidatingReceipts()
    }
    
    func startValidatingReceipts() {
        
        do {
            // try to get the local receipt that is avalible in every app
            _ = try getReceiptURL()?.checkResourceIsReachable()
            
            do {
                
                let receiptData = try Data(contentsOf: self.getReceiptURL()!)
                
                // Start validating the receipt with iTunes Server
                self.validateData(data: receiptData)
                print("Receipt Exists")
                
            } catch {
                print("Not able to get data from URL")
            }
            
        } catch {
            
            // Now if we try to load the receipt from local and for some reason the url dosen't exist, we need to make SKReceiptRefreshRequest we mentioned earlier
            guard UserDefaults.standard.bool(forKey: "didRefreshReceipt") == false else {
                // If receipt is set to true then return
                print("Stopping after a second attempt")
                return
            }
            
            UserDefaults.standard.set(true, forKey: "didRefreshReceipt")
            
            let receiptRequest = SKReceiptRefreshRequest()
            receiptRequest.delegate = self
            receiptRequest.start()
            
            print("Receipt URL dosen't exist ", error.localizedDescription)
        }
    }
    
    func getReceiptURL() -> URL? {
        return Bundle.main.appStoreReceiptURL
    }
    
    // Take data as param and start validating
    func validateData(data: Data) {
        
        // first we encode the data to base64
        let receiptsString = data.base64EncodedString(options: Data.Base64EncodingOptions.init(rawValue: 0))
        
        // Wrap data with our Shared Secret Key and send it to apple server
        var dic: [String: AnyObject] = ["receipt-data": receiptsString as AnyObject]
        
        let sharedSecret = "c9cd9584f0a24f1f826a7cdb632418dd"
        dic["password"] = sharedSecret as AnyObject?
        
        // Serialize the dictionary to JSON data
        let json = try! JSONSerialization.data(withJSONObject: dic, options: [])
        
        // Create a urlRequest
        var urlRequest = URLRequest(url: ReceiptValidationiTunesURLS.url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = json
        
        // Use the shared URLSessions to send the request
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            
            if let receiptData = data {
                
                self.handleData(data: receiptData)
                
            } else {
                print("Error validating receipt with itunes connect")
            }
            
        }
        
        // We need to tell the task to start
        task.resume()
    }
    
    
    // Function to hanlde returned data
    func handleData(data: Data) {
        
        // First decode data back to JSON
        guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary else {
            print("Not able to encode the jsonObject")
            return
        }
        
        // Check for the status value
        guard let status = json?["status"] as? NSNumber else { return }
        
        if status == 0 {
            // status OK
            
            // Get the receipt dictionary
            let receipt = json?["receipt"] as! NSDictionary
            
            // Get the In-App Purchases
            guard let inApps = receipt["in_app"] as? [NSDictionary] else {
                print("No In-App purchases avalible")
                return
            }
            
            var x = 1
            // Loop through each In-App and check for the values we discussed earlier 
            for inApp in inApps {
                
                print(inApp)
                print(x)
                x += 1
                // Since we will only be interested in subscriptions
                guard let expiryDate = inApp["expires_date_ms"] as? NSString else {
                    // It's not a subscription production since it has no expiry_date_ms field
                    // If it's not subscription then skip this item
                    continue
                }
                
//                let purchaseDate = (inApp["purchase_date_ms"] as? NSString)?.doubleValue
//                
//                let productID = inApp["product_id"]
//                let transactionID = inApp["transaction_id"]
                
//                let isTrial = inApp["is_trial_period"] as? NSString
                
                self.checkSubscriptionStatus(date: Date.init(timeIntervalSince1970: expiryDate.doubleValue / 1000))
                self.saveTrial(isTrial: true)
                // uncomment the bottm and delete the top in production
//                self.saveTrial(isTrial: isTrial!.boolValue)
            }
            
            //Let's post a notification when the receipt is updated so we can update our UI the collectionView to see if user is subscribed
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "ReceiptDidUpdated"), object: nil)
            
        } else {
            print("Error validating receipts - data not correct")
        }
    }
}





// Extension for the ReceiptManager class which we will have our logic for checking the subscription status
extension ReceiptManager {
    
    func checkSubscriptionStatus(date: Date) {
        
        // In this fucntion we will check for the expiry date of the subscription to see if it's newer then now, if so,
        // the user is subscribed to this product
        
        let calendar = Calendar.current
        let now = Date()
        
        let order = calendar.compare(now, to: date, toGranularity: .minute)
        
        switch order {
        case .orderedAscending,.orderedSame:
            print("User subscribed")
            self.saveActiveSubscription(date: date)
        case .orderedDescending:
            print("User subscription has expired")
        }
    }
    
    // Handy function to tell us if user is subscribed or not
    var isSubscribed: Bool {
        guard let currentActiveSubscription = UserDefaults.standard.object(forKey: "activeSubscriptionKey") as? Date else {
            return false
        }
        
        //This way we check for date everytime we call this variable
        return currentActiveSubscription.timeIntervalSince1970 > Date().timeIntervalSince1970 // NOW
    }
    
    // var to tell us if user is on trail period
    var isTrial: Bool {
        return UserDefaults.standard.bool(forKey: "isUserTrialPeriodKey")
    }
}




// This extension will include our UserDefault
extension ReceiptManager {
    
    func saveActiveSubscription(date: Date) {
        // Only one active subscription at a time in this app, so it will be either active or not
        UserDefaults.standard.set(date, forKey: "activeSubscriptionKey")
        UserDefaults.standard.synchronize()
    }
    
    func saveTrial(isTrial: Bool) {
        UserDefaults.standard.set(isTrial, forKey: "isUserTrialPeriodKey")
        UserDefaults.standard.synchronize()
    }
}



