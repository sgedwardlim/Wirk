//
//  StoreManager.swift
//  wirk
//
//  Created by Edward on 3/10/17.
//  Copyright © 2017 Edward. All rights reserved.
//

import Foundation
import StoreKit

class StoreManager: NSObject {
    
    /*
     *  This is a shared object of the StoreManager and you should only
     *  access their methods through the shared object
    */
    static var shared: StoreManager = {
        return StoreManager()
    }()
    
    /* Array to hold our SKProducts received from the store after request */
    var productsFromStore = [SKProduct]()
    
    /* Array to hold our productsID for our app purchases */
    let purchasableProductsIds: Set<String> = ["com.sgedwardlim.wirk.monthly","com.sgedwardlim.wirk.yearly"]
    
    /* Array to hold only subscrptions */
    let autoSubscriptionIds: Set<String> = ["com.sgedwardlim.wirk.monthly","com.sgedwardlim.wirk.yearly"]
    
    /* Instantiate receipt manager class */
    var receiptManager: ReceiptManager = ReceiptManager()
    
    func setup() {
        
        // In order to display products for the user, the first thing we need to do is request
        // our SKProduct form the store so we can show the product in out app and make it avalible 
        // for purchasing
        
        
        // Call our setup method when app launches and best place to do so is in AppDelegate
        requestProducts(ids: purchasableProductsIds)
        
        // We need to become the delegate for SKPaymentTransaction
        SKPaymentQueue.default().add(self)
    }
    
    // Load our products when the app launches and prepare them for us
    // 1- Request products by product id from the store
    func requestProducts(ids: Set<String>) {
        
        // Before we make any payments we need to check if user can make payments
        if SKPaymentQueue.canMakePayments() {
            
            // Create the request which we will send to store
            // Note that we can request for more then one product at once
            let request = SKProductsRequest(productIdentifiers: ids)

            // Now we need to become the delegate for the request so we can get responses
            request.delegate = self
            request.start()
        } else {
            print("User can't make payments from this account")
        }
    }
    
}

// In order to receive the calls we need to implement the delgate methods of SKProductsRequestDelegate

extension StoreManager: SKProductsRequestDelegate {
    
    // This methods will be called whenever the request finished processing on the Store
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        // Int the response there are products SKProduct we requested in the request
        let products =  response.products 
        if products.count > 0 {
            
            // Loop through each product
            for product in products {
                // add it to our array for later use
                self.productsFromStore.append(product)
            }
            // should return 2
            print("number of products in store, ", products.count)
        } else {
            print("Products not found")
        }
        
        // Notification when our products have loaded
        NotificationCenter.default.post(name: NSNotification.Name.init("SKProductsHaveLoaded"), object: nil)
        
        // We can also check to see if we have sent the wrong product ids
        let invalidProductsIDs = response.invalidProductIdentifiers
        
        for id in invalidProductsIDs {
            print("Wrong product id: ", id)
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Error requesting products from the store", error.localizedDescription)
    }
    
    func buy(product: SKProduct) {
        
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
        print("Buying product: ", product.productIdentifier)
    }
    
}

// We also need to implement the delegate methods for the SKPaymentTransactionObserver
extension StoreManager: SKPaymentTransactionObserver {
    
    //Two methods we will be interested in:
    
    // This method will be called whenever there is an update from the store about a product or subscription etc...
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        // Loop through transactions and check their statues
        
        for transaction in transactions {
            
            switch transaction.transactionState {
            case .purchased:
                purchaseCompleted(transaction: transaction)
            case .failed:
                purchaseFailed(transaction: transaction)
            case .restored:
                purchaseRestored(transaction: transaction)
            case .purchasing,.deferred:
                print("Pending")
            }
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        print("Restored finished processing all completed transactions")
    }
        
    // Implement different functions for each state of transaction
    func purchaseCompleted(transaction: SKPaymentTransaction) {
        unlockContentForTransaction(transaction: transaction)
        // Only after we have unlocked content for the user
        SKPaymentQueue.default().finishTransaction(transaction)
    }
        
    func purchaseFailed(transaction: SKPaymentTransaction) {
        
        // In the case in which our transaction failed we need to check why
        if let error = transaction.error as? SKError {
            switch error {
            case SKError.clientInvalid:
                print("User not allowed to make payment request")
            case SKError.unknown:
                print("Unknown error while processing payment")
            case SKError.paymentCancelled:
                print("User canceled payment request")
            case SKError.paymentInvalid:
                print("The pruchase id was not valid")
            case SKError.paymentNotAllowed:
                print("This device is not allowed to make payments")
            default:
                break
            }
        }
        
        // Only after we have unlocked content for the user
        SKPaymentQueue.default().finishTransaction(transaction)
    }
        
    func purchaseRestored(transaction: SKPaymentTransaction) {
        unlockContentForTransaction(transaction: transaction)
        // Only after we have unlocked content for the user
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    // This function will unlock whichever transaction we have for the productID
    func unlockContentForTransaction(transaction: SKPaymentTransaction) {
        
        print("Should unlock content for product ID: ", transaction.payment.productIdentifier)
        
        // Implement code required to unlock content user purchased
        
        // Checks all the avalible subscription products
        if self.autoSubscriptionIds.contains(transaction.payment.productIdentifier) {
            // Now lets check our subscription transactions since we only have one
            if transaction.payment.productIdentifier == "com.sgedwardlim.wirk.monthly" {
                // User purchased this subscription, tell the ReceiptManager to refresh the receipt 
                // so our app will get updated with the latest expiry date of subscription
                receiptManager.startValidatingReceipts()
            }
        }
    }
}















