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
        print("Saved")
    }
    
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
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info["UIImagePickerControllerOriginalImage"] as? UIImage else {
            return
        }
        
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
