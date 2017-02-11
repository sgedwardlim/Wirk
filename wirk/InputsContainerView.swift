//
//  InputsContainerView.swift
//  wirk
//
//  Created by Edward on 2/10/17.
//  Copyright © 2017 Edward. All rights reserved.
//

import UIKit

class InputsContainerView: UIView {
    
    // MARK: Properties
    let companyNameField: UITextField = {
        let name = UITextField()
        name.placeholder = "Company name"
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    let companyNameSeperator: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailField: UITextField = {
        let email = UITextField()
        email.placeholder = "Email"
        email.translatesAutoresizingMaskIntoConstraints = false
        return email
    }()
    
    let emailFieldSeperator: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordField: UITextField = {
        let pass = UITextField()
        pass.placeholder = "Password"
        pass.isSecureTextEntry = true
        pass.translatesAutoresizingMaskIntoConstraints = false
        return pass
    }()
    
    var companyNameFieldHeightAnchor: NSLayoutConstraint?
    var emailFieldHeightAnchor: NSLayoutConstraint?
    var passwordFieldHeightAnchor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(companyNameField)
        addSubview(companyNameSeperator)
        addSubview(emailField)
        addSubview(emailFieldSeperator)
        addSubview(passwordField)
        
        // x, y, width and height constraints for the companyNameField
        companyNameField.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        companyNameField.topAnchor.constraint(equalTo: topAnchor).isActive = true
        companyNameField.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        companyNameFieldHeightAnchor = companyNameField.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/3)
        companyNameFieldHeightAnchor?.isActive = true
        
        // x, y, width and height constraints for the companyNameSeperator
        companyNameSeperator.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        companyNameSeperator.topAnchor.constraint(equalTo: companyNameField.bottomAnchor).isActive = true
        companyNameSeperator.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        companyNameSeperator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        // x, y, width and height constraints for the emailField
        emailField.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        emailField.topAnchor.constraint(equalTo: companyNameField.bottomAnchor).isActive = true
        emailField.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        emailFieldHeightAnchor = emailField.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/3)
        emailFieldHeightAnchor?.isActive = true
        
        // x, y, width and height constraints for the emailFieldSeperator
        emailFieldSeperator.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        emailFieldSeperator.topAnchor.constraint(equalTo: emailField.bottomAnchor).isActive = true
        emailFieldSeperator.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        emailFieldSeperator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        // x, y, width and height constraints for the passwordField
        passwordField.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor).isActive = true
        passwordField.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        passwordFieldHeightAnchor = passwordField.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/3)
        passwordFieldHeightAnchor?.isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
