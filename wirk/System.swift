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
    
    static let sharedInstance = System()
    static let ref = FIRDatabase.database().reference()
    
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
    
    
//    private func updateUserToDatabase(withName name: String, email: String, completion: @escaping (Error?) -> ()) {
//        let values = ["name": name,
//                      "email": email]
//        System.ref.child("users").updateChildValues(values) { (error, ref) in
//            // returns an object of optional error for the caller to handle
//            completion(error)
//        }
//    }
}
