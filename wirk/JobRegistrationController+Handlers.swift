//
//  JobRegistrationController+Handlers.swift
//  wirk
//
//  Created by Edward on 2/15/17.
//  Copyright © 2017 Edward. All rights reserved.
//

import UIKit

extension JobRegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {    
    
    func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func handleSave() {
        // disable the save button
        saveButton.isEnabled = false
        // retreive all the data in all the fields
        let jobType = jobTypeField.text
        let jobDescription = jobDescriptionField.text
        let beforeImage = beforeImageView.image
        let afterImage = afterImageView.image
        
        // unwrap the job and upload to database
        if let job = job {
            job.jobType = jobType
            job.jobDescription = jobDescription
            job.beforeImage = beforeImage
            job.afterImage = afterImage
            System.sharedInstance.updateJobToDatabase(with: job, customerKey: job.customerKey) {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // MARK: Image Selection Functions
    func handleBeforeImageSelected() {
        let picker = UIImagePickerController()
        picker.delegate = self
        imageType = .before
        present(picker, animated: true, completion: nil)
    }
    
    func handleAfterImageSelected() {
        let picker = UIImagePickerController()
        picker.delegate = self
        imageType = .after
        present(picker, animated: true, completion: nil)
    }
    
    // MARK: Image Picker Delegate Functions
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info["UIImagePickerControllerOriginalImage"] as? UIImage else {
            return
        }
        // determine which image was selected by the user
        switch imageType {
        case .before:
            beforeImageView.image = selectedImage
            break
        case .after:
            afterImageView.image = selectedImage
            break
        }
        dismiss(animated: true, completion: nil)
    }
}
