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
        print("login button tapped")
        dismiss(animated: true, completion: nil)
    }
    
    private func handleRegisterButtonTapped() {
        print("register button tapped")
        dismiss(animated: true, completion: nil)
    }
}
