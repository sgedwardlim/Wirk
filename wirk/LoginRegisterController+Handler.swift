//
//  LoginRegisterController+Handler.swift
//  wirk
//
//  Created by Edward on 2/10/17.
//  Copyright © 2017 Edward. All rights reserved.
//

import UIKit

extension LoginRegisterController {
    
    enum LoginRegisterSegments: String {
        case login = "Login"
        case register = "Register"
    }
    
    func handleLoginRegisterChange() {
        // get current selected segment title
        guard let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex) else {
            return
        }
        
        // change the loginRegisterButton title
        loginRegisterButton.setTitle(title, for: .normal)
        
        // Change the height of the inputs container view depending on the segment selected
        inputsContainerViewHeightAnchor?.constant = title == LoginRegisterSegments.login.rawValue ? 80 : 120
        
        // Handles the hiding or showing of the comanyNameField within inputsContainerView
        inputsContainerView.companyNameField.isHidden = title == LoginRegisterSegments.login.rawValue ? true : false
        inputsContainerView.companyNameSeperator.isHidden = title == LoginRegisterSegments.login.rawValue ? true : false
        
        inputsContainerView.companyNameFieldHeightAnchor?.isActive = false
        inputsContainerView.companyNameFieldHeightAnchor = inputsContainerView.companyNameField.heightAnchor.constraint(
            equalTo: inputsContainerView.heightAnchor,
            multiplier: title == LoginRegisterSegments.login.rawValue ? 0 : 1/3
        )
        inputsContainerView.companyNameFieldHeightAnchor?.isActive = true
        
        // Change the heights of emailFields and passwordFields to match smaller inputsContainerView
        inputsContainerView.emailFieldHeightAnchor?.isActive = false
        inputsContainerView.emailFieldHeightAnchor = inputsContainerView.emailField.heightAnchor.constraint(
            equalTo: inputsContainerView.heightAnchor,
            multiplier: title == LoginRegisterSegments.login.rawValue ? 1/2 : 1/3
        )
        inputsContainerView.emailFieldHeightAnchor?.isActive = true
        
        inputsContainerView.passwordFieldHeightAnchor?.isActive = false
        inputsContainerView.passwordFieldHeightAnchor = inputsContainerView.passwordField.heightAnchor.constraint(
            equalTo: inputsContainerView.heightAnchor,
            multiplier: title == LoginRegisterSegments.login.rawValue ? 1/2 : 1/3
        )
        inputsContainerView.passwordFieldHeightAnchor?.isActive = true
    }
    
    func handleLoginRegisterButtonTapped() {
        // get current selected segment title
        guard let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex) else {
            return
        }
        // Login the user
        if title == LoginRegisterSegments.login.rawValue {
            handleLoginButtonTapped()
        } else {
            handleRegisterButtonTapped()
        }
    }
    
    private func handleLoginButtonTapped() {
        let email = inputsContainerView.emailField.text
        let pass = inputsContainerView.passwordField.text
        System.sharedInstance.loginUser(withEmail: email, password: pass) { (error) in
            if let error = error {
                // User was unsucessful in logging in
                self.displayAlert("Error", message: error.localizedDescription)
                return
            }
            // Success in logging in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func handleRegisterButtonTapped() {
        let name = inputsContainerView.companyNameField.text
        let email = inputsContainerView.emailField.text
        let pass = inputsContainerView.passwordField.text
        
        System.sharedInstance.registerUser(withEmail: email, pass: pass, name: name) { (error) in
            if let error = error {
                // User was unsucessful in being added to the database
                // Perhaps delete user from database and ask user to try again
                self.displayAlert("Error", message: error.localizedDescription)
                return
            }
            // Succesfully added user into database, proceed
            self.dismiss(animated: true, completion: nil)
        }
    }
}
