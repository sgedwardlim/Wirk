//
//  System.swift
//  wirk
//
//  Created by Edward on 2/10/17.
//  Copyright © 2017 Edward. All rights reserved.
//

import Foundation
import Firebase
import CoreLocation

final class System {
    
    // MARK: Properties
    static let sharedInstance = System()
    static let ref = FIRDatabase.database().reference()
    static let customerRef = FIRDatabase.database().reference().child("customers")
    static let jobRef = FIRDatabase.database().reference().child("jobs")
    static let uid = FIRAuth.auth()?.currentUser?.uid
    
    
    
    // MARK: Customer Related Database Functions
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
    func updateCustomerToDatabase(with customer: Customer) {
        let values: [String : Any] = ["first": customer.first as Any,
                                      "middle": customer.middle as Any,
                                      "last": customer.last as Any,
                                      "location": customer.location as Any,
                                      "phone": customer.phone as Any,
                                      "email": customer.email as Any,
                                      "privacy": customer.privacy as Any,
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
    
    // MARK: Job Related Database Functions
    func observeJobsDatabase(completion: @escaping ([Job]) -> ()) {
        guard let uid = System.uid else { return }
        
        // Observe all customer id's within the Jobs node in FIREBASE
        System.jobRef.child(uid).observe(.value, with: { (snapshot) in
            var jobs = [Job]()
            // Loop through every customer node in jobs database and save the key
            for customerSnap in snapshot.children {
                let customerSnap = customerSnap as! FIRDataSnapshot
                let customerKey = customerSnap.key
                
                // Retreive the location of the customer
                System.customerRef.child(uid).child(customerKey).observe(.value, with: { (snapshot) in
                    let dict = snapshot.value as? [String: Any]
                    let location = dict?["location"] as? String
                    
                    // loop through every job for every customer in the job database
                    for jobSnap in customerSnap.children {
                        let jobSnap = jobSnap as! FIRDataSnapshot
                        let job = Job(withSnapshot: jobSnap, belongsTo: customerKey)
                        // Safely unwrap optional location
                        if let jobLocation = location {
                            LocationManager.forwardGeocoding(for: jobLocation, completionHandler: { (placemark) in
                                job.placemark = placemark
                                job.location = location
                                LocationManager.getCityAndZip(with: placemark, completion: { (city, zip) in
                                    // Initalize these values here so that we can easily filter them in the jobController
                                    job.city = city
                                    job.zip = zip
                                    jobs.insert(job, at: 0)
                                    completion(jobs)
                                })
                                
                            })
                        }
                    }
                })
            }
        })
    }
    
    // Observe any changes to the jobs node in FIREBASE and notifies the caller
    func observeJobsDatabase(customer: Customer?, completion: @escaping ([Job]) -> ()) {
        guard let uid = System.uid else {
            return
        }
        guard let customerKey = customer?.key else {
            return
        }
        
        System.jobRef.child(uid).child(customerKey).observe(.value, with: { (snapshot) in
            var jobs = [Job]()
            
            for jobSnapshot in snapshot.children {
                let job = Job(withSnapshot: jobSnapshot as! FIRDataSnapshot, belongsTo: customerKey)
                jobs.insert(job, at: 0)
            }
            completion(jobs)
        })
    }
    
    // Remove all observers for the customers node
    func removeJobsObserver() {
        System.jobRef.removeAllObservers()
    }
    
    // Uploads a customer to the database
    func updateJobToDatabase(with job: Job, customerKey: String?, completion: @escaping () -> ()) {
        // If user is currently not logged in, then adding to database is not possible, return
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        // All instances of job have to belong to a customer, else return
        guard let customerKey = customerKey else { return }
        // Create a counter to ensure that both before and after images have successfully uploaded
        var uploadCount = 2
        
        uploadImageToDatabase(with: job.beforeImage, uid, customerKey, job.beforeImageKey) { (beforeImageUrl) in
            job.beforeImageUrl = beforeImageUrl
            uploadCount -= 1
            // Check if all images have successfully uploaded, notify completion handler if so
            if uploadCount == 0 {
                self.updateValuesForJob(with: job, uid, customerKey)
                completion()
            }
        }
        
        uploadImageToDatabase(with: job.afterImage, uid, customerKey, job.afterImageKey) { (afterImageUrl) in
            job.afterImageUrl = afterImageUrl
            uploadCount -= 1
            // Check if all images have successfully uploaded, notify completion handler if so
            if uploadCount == 0 {
                self.updateValuesForJob(with: job, uid, customerKey)
                completion()
            }
        }
    }
    
    private func updateValuesForJob(with job: Job, _ uid: String, _ customerKey: String) {
        let values: [String : Any] = ["jobType": job.jobType!,
                                      "jobDescription": job.jobDescription!,
                                      "beforeImageKey": job.beforeImageKey!,
                                      "beforeImageUrl": job.beforeImageUrl!,
                                      "afterImageKey": job.afterImageKey!,
                                      "afterImageUrl": job.afterImageUrl!]
        if let jobKey = job.key {
            // If successfully unwraped, then editing existing job
            System.jobRef.child(uid).child(customerKey).child(jobKey).updateChildValues(values)
        } else {
            // creating new instance of job
            System.jobRef.child(uid).child(customerKey).childByAutoId().updateChildValues(values)
        }
    }
    
    // returns the download url for the image if it was successfully uploaded into the database
    private func uploadImageToDatabase(with image: UIImage?, _ uid: String, _ customerKey: String, _ imageKey: String?, completion: @escaping (String?)->()) {
        // Check if image was added by user.
        guard let image = image else { return }
        // Create a JPEG img and compress its quality to 1/10 of its original
        let uploadData = UIImageJPEGRepresentation(image, 0.1)
        // Unwrap image key
        guard let imageKey = imageKey else { return }
        // Create a ref to the storage location of image
        let storageRef = FIRStorage.storage().reference().child(uid).child(customerKey).child(imageKey)
        storageRef.put(uploadData!, metadata: nil) { (metadata, error) in
            
            if error != nil {
                return
            }
            // successfully uploaded image into FIREStorage
            completion(metadata?.downloadURL()?.absoluteString)
        }
    }
    
    func deleteImageFiles(for job: Job, customerKey: String?) {
        // Check if user is logged in, else return
        guard let uid = System.uid else { return }
        // check if customer key exist
        guard let customerKey = customerKey else { return }
        // Ensure that the file to be deleted is in the database
        guard let beforeImageKey = job.beforeImageKey else { return }
        guard let afterImageKey = job.afterImageKey else { return }
        // Create a reference to the  beforeImage file to delete
        let beforeImagePath = "\(uid)/\(customerKey)/\(beforeImageKey)"
        deleteFileFromDatabase(withPath: beforeImagePath)
        // Create a reference to the afterImage file to delete
        let afterImagePath = "\(uid)/\(customerKey)/\(afterImageKey)"
        deleteFileFromDatabase(withPath: afterImagePath)
    }
    
    /** 
        This function deletes anyfile from the FIREBASE DATABASE with said
        path passed as parameter, it does not handle the error but simply 
        prints out the description of the error, else file deleted
    */
    private func deleteFileFromDatabase(withPath path: String) {
        let storageRef = FIRStorage.storage().reference().child(path)
        // Delete the before image file, if error, dont handle
        storageRef.delete { error in
        
            // check if error exist, else successfully deleted
            if let error = error {
                print(error.localizedDescription)
                return
            }
        }
    }
    
    // MARK: User registration and login functions
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


// MARK: Required to determine the different types of images in this application
enum ImageTypes {
    case before
    case after
}
