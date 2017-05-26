//
//  SettingsController.swift
//  wirk
//
//  Created by Edward on 2/10/17.
//  Copyright © 2017 Edward. All rights reserved.
//

import UIKit

class SettingsController: UIViewController {
    
    // MARK: Properties
    lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Logout", for: .normal)
        button.titleLabel?.textColor = .lightGray
        // method is decalred in an extention to UIViewController
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        return button
    }()
    
    let emailSectionTitle: UILabel = {
        let label = UILabel()
        label.text = "Email Recipient"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emailFieldContainer: UIView = {
        let container = UIView()
        container.backgroundColor = UIColor(colorType: .background)
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    lazy var companyNameField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Company Name"
        textField.backgroundColor = UIColor(colorType: .background)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let companyNameDividerLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var emailSubjectField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email subject"
        textField.backgroundColor = UIColor(colorType: .background)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let emailSubjectDividerLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var emailMessageField: UITextView = {
        let textField = UITextView()
        textField.placeholder = "Email description"
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.backgroundColor = UIColor(colorType: .background)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var currentSelectedTextField: UITextField?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadUserPreferences()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let name = companyNameField.text!
        let subject = emailSubjectField.text!
        let message = emailMessageField.text!
        UserPreferences.updatePreferencesToUserDefaults(companyName: name, emailSubject: subject, emailMessage: message)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismissKeyboard))
        view.addGestureRecognizer(tap)
        
        navigationItem.title = "Settings"
        navigationController?.navigationBar.tintColor = .black
        
        // Need so that view controller is not behind nav controller
        self.edgesForExtendedLayout = []
        view.backgroundColor = UIColor(netHex: 0xF0F0F0)
        
        view.addSubview(logoutButton)
        view.addSubview(emailSectionTitle)
        
        emailSectionTitle.heightAnchor.constraint(equalToConstant: 26).isActive = true
        emailSectionTitle.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        emailSectionTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        emailSectionTitle.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        setupEmailFieldContainerView()
        
        logoutButton.topAnchor.constraint(equalTo: emailFieldContainer.bottomAnchor).isActive = true
        logoutButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        logoutButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    private func setupEmailFieldContainerView() {
        // encapsulate the email message fields into the container view, used to create illusion of padded fields
        view.addSubview(emailFieldContainer)
        emailFieldContainer.addSubview(companyNameField)
        emailFieldContainer.addSubview(companyNameDividerLine)
        emailFieldContainer.addSubview(emailSubjectField)
        emailFieldContainer.addSubview(emailSubjectDividerLine)
        emailFieldContainer.addSubview(emailMessageField)
        
        emailFieldContainer.heightAnchor.constraint(equalToConstant: 40 + 40 + 0.5 + 0.5 + 100 + 0.5).isActive = true
        emailFieldContainer.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        emailFieldContainer.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        emailFieldContainer.topAnchor.constraint(equalTo: emailSectionTitle.bottomAnchor).isActive = true
        
        companyNameField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        companyNameField.topAnchor.constraint(equalTo: emailFieldContainer.topAnchor).isActive = true
        companyNameField.leftAnchor.constraint(equalTo: emailFieldContainer.leftAnchor, constant: 8).isActive = true
        companyNameField.rightAnchor.constraint(equalTo: emailFieldContainer.rightAnchor).isActive = true
        
        companyNameDividerLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        companyNameDividerLine.topAnchor.constraint(equalTo: companyNameField.bottomAnchor).isActive = true
        companyNameDividerLine.leftAnchor.constraint(equalTo: emailFieldContainer.leftAnchor, constant: 8).isActive = true
        companyNameDividerLine.rightAnchor.constraint(equalTo: emailFieldContainer.rightAnchor).isActive = true
        
        emailSubjectField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        emailSubjectField.topAnchor.constraint(equalTo: companyNameDividerLine.bottomAnchor).isActive = true
        emailSubjectField.leftAnchor.constraint(equalTo: emailFieldContainer.leftAnchor, constant: 8).isActive = true
        emailSubjectField.rightAnchor.constraint(equalTo: emailFieldContainer.rightAnchor).isActive = true
        
        emailSubjectDividerLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        emailSubjectDividerLine.topAnchor.constraint(equalTo: emailSubjectField.bottomAnchor).isActive = true
        emailSubjectDividerLine.leftAnchor.constraint(equalTo: emailFieldContainer.leftAnchor, constant: 8).isActive = true
        emailSubjectDividerLine.rightAnchor.constraint(equalTo: emailFieldContainer.rightAnchor).isActive = true
        
        emailMessageField.heightAnchor.constraint(equalToConstant: 100).isActive = true
        emailMessageField.topAnchor.constraint(equalTo: emailSubjectDividerLine.bottomAnchor).isActive = true
        emailMessageField.leftAnchor.constraint(equalTo: emailFieldContainer.leftAnchor, constant: 4).isActive = true
        emailMessageField.rightAnchor.constraint(equalTo: emailFieldContainer.rightAnchor).isActive = true
    }
    
    private func loadUserPreferences() {
        self.companyNameField.text = UserPreferences.getCompanyName()
        self.emailSubjectField.text = UserPreferences.getEmailSubject()
        self.emailMessageField.text = UserPreferences.getEmailMessage()
        self.emailMessageField.textViewDidChange(emailMessageField)
    }
    
    func handleDismissKeyboard() {
        view.endEditing(true)
    }
}

extension SettingsController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleDismissKeyboard()
        return true
    }
    
}




















