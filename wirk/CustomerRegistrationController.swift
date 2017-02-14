//
//  CustomerController.swift
//  wirk
//
//  Created by Edward on 2/11/17.
//  Copyright © 2017 Edward. All rights reserved.
//

import UIKit

/*
 This class represents page shown when the user tries to create a new
 customer for the database
 */
class CustomerRegistrationController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: Properties
    lazy var cancelButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        return button
    }()
    
    lazy var saveButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(handleSave))
        return button
    }()
    
    private let jobCellId = "jobCellId"
    private let headerCellId = "headerCellId"
    var customerHeaderCell: CustomerHeaderCell?
    var customer: Customer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor(colorType: .background)
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton
        
        collectionView?.register(JobCell.self, forCellWithReuseIdentifier: jobCellId)
        collectionView?.register(CustomerHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerCellId)
    }
    
    // MARK: Collection View Data Source Functions
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: jobCellId, for: indexPath) as! JobCell
        return cell
    }
    // MARK: Collection View Header Functions
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 230)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerCellId, for: indexPath) as! CustomerHeaderCell
        customerHeaderCell = cell
        customerHeaderCell?.customer = customer
        return cell
    }
    
    // MARK: Collection View FLow Layout Function
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}






class CustomerHeaderCell: BaseCell {
    //MARK: Properties
    var customer: Customer? {
        didSet{
            // if customer is nil, then is a new customer
            guard let customer = customer else { return }
            
            firstNameField.text = customer.first
            middleNameField.text = customer.middle
            lastNameField.text = customer.last
            locationField.text = customer.location
            phoneField.text = customer.phone
            emailField.text = customer.email
        }
    }
    
    var firstNameField: UITextField = {
        let field = UITextField()
        field.placeholder = "First"
        field.font = UIFont.systemFont(ofSize: 16)
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    let firstDividerLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var middleNameField: UITextField = {
        let field = UITextField()
        field.placeholder = "Middle"
        field.font = UIFont.systemFont(ofSize: 16)
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    let middleDividerLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var lastNameField: UITextField = {
        let field = UITextField()
        field.placeholder = "First"
        field.font = UIFont.systemFont(ofSize: 16)
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    let lastDividerLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var locationField: UITextField = {
        let field = UITextField()
        field.placeholder = "Location"
        field.font = UIFont.systemFont(ofSize: 16)
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    let locationDividerLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var phoneField: UITextField = {
        let field = UITextField()
        field.placeholder = "Phone"
        field.font = UIFont.systemFont(ofSize: 16)
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    let phoneDividerLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var emailField: UITextField = {
        let field = UITextField()
        field.placeholder = "Email"
        field.font = UIFont.systemFont(ofSize: 16)
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    let emailDividerLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var addJobButton: UIButton = {
        let button = UIButton()
        button.setTitle("New Job", for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.backgroundColor = UIColor(colorType: .button)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleAddJob), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let headerDividerLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func setupViews() {
        addSubview(firstNameField)
        addSubview(firstDividerLine)
        addSubview(middleNameField)
        addSubview(middleDividerLine)
        addSubview(lastNameField)
        addSubview(lastDividerLine)
        addSubview(locationField)
        addSubview(locationDividerLine)
        addSubview(phoneField)
        addSubview(phoneDividerLine)
        addSubview(emailField)
        addSubview(emailDividerLine)
        addSubview(addJobButton)
        addSubview(headerDividerLine)
        
        // x, y, width and height constrants iOS - 9 above
        firstNameField.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        firstNameField.topAnchor.constraint(equalTo: topAnchor).isActive = true
        firstNameField.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        firstNameField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        // x, y, width and height constrants iOS - 9 above
        firstDividerLine.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        firstDividerLine.bottomAnchor.constraint(equalTo: firstNameField.bottomAnchor).isActive = true
        firstDividerLine.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        firstDividerLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        // x, y, width and height constrants iOS - 9 above
        middleNameField.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        middleNameField.topAnchor.constraint(equalTo: firstNameField.bottomAnchor).isActive = true
        middleNameField.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        middleNameField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        // x, y, width and height constrants iOS - 9 above
        middleDividerLine.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        middleDividerLine.bottomAnchor.constraint(equalTo: middleNameField.bottomAnchor).isActive = true
        middleDividerLine.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        middleDividerLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        // x, y, width and height constrants iOS - 9 above
        lastNameField.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        lastNameField.topAnchor.constraint(equalTo: middleNameField.bottomAnchor).isActive = true
        lastNameField.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        lastNameField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        // x, y, width and height constrants iOS - 9 above
        lastDividerLine.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        lastDividerLine.bottomAnchor.constraint(equalTo: lastNameField.bottomAnchor).isActive = true
        lastDividerLine.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        lastDividerLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        // x, y, width and height constrants iOS - 9 above
        locationField.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        locationField.topAnchor.constraint(equalTo: lastNameField.bottomAnchor).isActive = true
        locationField.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        locationField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        // x, y, width and height constrants iOS - 9 above
        locationDividerLine.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        locationDividerLine.bottomAnchor.constraint(equalTo: locationField.bottomAnchor).isActive = true
        locationDividerLine.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        locationDividerLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        // x, y, width and height constrants iOS - 9 above
        phoneField.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        phoneField.topAnchor.constraint(equalTo: locationField.bottomAnchor).isActive = true
        phoneField.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        phoneField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        // x, y, width and height constrants iOS - 9 above
        phoneDividerLine.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        phoneDividerLine.bottomAnchor.constraint(equalTo: phoneField.bottomAnchor).isActive = true
        phoneDividerLine.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        phoneDividerLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        // x, y, width and height constrants iOS - 9 above
        emailField.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        emailField.topAnchor.constraint(equalTo: phoneField.bottomAnchor).isActive = true
        emailField.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        emailField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        // x, y, width and height constrants iOS - 9 above
        emailDividerLine.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        emailDividerLine.bottomAnchor.constraint(equalTo: emailField.bottomAnchor).isActive = true
        emailDividerLine.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        emailDividerLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        // x, y, width and height constrants iOS - 9 above
        addJobButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        addJobButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        addJobButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        addJobButton.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 8).isActive = true
        
        // x, y, width and height constrants iOS - 9 above
        headerDividerLine.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        headerDividerLine.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        headerDividerLine.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        headerDividerLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }
}

class JobCell: BaseCell {
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "TEST"
        return label
    }()
    
    override func setupViews() {
        backgroundColor = .green
        
    }
}


