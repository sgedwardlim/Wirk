//
//  System.swift
//  wirk
//
//  Created by Edward on 2/10/17.
//  Copyright © 2017 Edward. All rights reserved.
//

import Foundation
import Firebase

final class System {
    
    // MARK: Properties
    static let sharedInstance = System()
    static let ref = FIRDatabase.database().reference()
    static let customerRef = FIRDatabase.database().reference().child("customers")
    static let uid = FIRAuth.auth()?.currentUser
    
    
    
    // Observe any changes to the customers node in FIREBASE and notify the caller
    func observeCustomersDatabase(completion: @escaping ([Customer]) -> ()) {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        System.customerRef.child(uid).queryOrdered(byChild: "timestamp").observe(.value, with: { (snapshot) in
            var customers = [Customer]()
            
            for customerSnapShot in snapshot.children {
                let customer = Customer(withSnapshot: customerSnapShot as! FIRDataSnapshot)
                // This ensures that the list is reversed
                customers.insert(customer, at: 0)
            }
            completion(customers)
        })
    }
    
    // Remove all observers for the customers node
    func removeCustomersObserver() {
        System.customerRef.removeAllObservers()
    }
    
    // Uploads a customer to the database
    func uploadToDatabase(with customer: Customer) {
        let values: [String : Any] = ["first": customer.first,
                                      "middle": customer.middle,
                                      "last": customer.last,
                                      "location": customer.location,
                                      "phone": customer.phone,
                                      "email": customer.email,
                                      "timestamp": FIRServerValue.timestamp()]
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        // Check if customer already exists in database
        if let customerKey = customer.key {
            System.ref.child("customers").child(uid).child(customerKey).updateChildValues(values)
        } else {
            // else create a new instance of the customer
            System.ref.child("customers").child(uid).childByAutoId().updateChildValues(values)
        }
    }
    
    // Registers a user to the FIREBASE DATABASE
    func registerUser(withEmail email: String?, pass: String?, name: String?, completion: @escaping (Error?) -> ()) {
        guard let email = email, let pass = pass, let name = name else {
            return
        }
        FIRAuth.auth()?.createUser(withEmail: email, password: pass, completion: { (user, error) in
            // Returns an error containing a localized message back to the caller
            if let error = error {
                completion(error)
                return
            }
            // Succesfully authenthucated user into database
            self.updateUserToDatabase(withUser: user, name, email)
            completion(error)
        })
    }
    
    private func updateUserToDatabase(withUser user: FIRUser?,_ name: String,_ email: String) {
        let values = ["name": name, "email": email]
        guard let uid = user?.uid else {
            return
        }
        System.ref.child("users").child(uid).updateChildValues(values)
    }
    
    func loginUser(withEmail email: String?, password: String?, completion: @escaping (Error?) -> ()) {
        guard let email = email, let password = password else {
            return
        }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                completion(error)
                return
            }
            completion(error)
        })
    }
    
    func logoutUser() {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}
