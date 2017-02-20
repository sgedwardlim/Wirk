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
class CustomerRegistrationController: UITableViewController {
    
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
    
    // MARK: View Functionalities
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initalizeCustomer()
        
        view.backgroundColor = UIColor(colorType: .background)
        tableView?.backgroundColor = UIColor(colorType: .background)
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton
        
        // This makes it so that it dosent show default empty cells
        tableView?.tableFooterView = UIView(frame: .zero)
        // Register the cells to be used by tableView
        tableView?.register(JobCell.self, forCellReuseIdentifier: jobCellId)
        tableView?.register(CustomerHeaderCell.self, forHeaderFooterViewReuseIdentifier: headerCellId)
    }
    
    // Creates a new customer in the database if customer dosent exist
    private func initalizeCustomer() {
        // check if customer has been initalized
        if customer == nil {
            guard let uid = System.uid else { return }
            let customerRef = System.customerRef.child(uid).childByAutoId()
            customer = Customer(withCustomerRef: customerRef)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        System.sharedInstance.observeJobsDatabase(customer: customer) { (jobs) in
            self.customer?.jobs = jobs
            self.tableView?.reloadData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        System.sharedInstance.removeJobsObserver()
    }
    
    // MARK: TableView Data Source Functions
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = customer?.jobs?.count {
            return count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: jobCellId, for: indexPath) as! JobCell
        cell.job = customer?.jobs?[indexPath.item]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let jobSelected = customer?.jobs?[indexPath.item]
        // present the job registration view controller
        let view = JobRegistrationController()
        view.job = jobSelected
        let nav = UINavigationController(rootViewController: view)
        present(nav, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let selectedJob = customer?.jobs?[indexPath.item] else {
                return
            }
            selectedJob.ref?.removeValue()
            System.sharedInstance.deleteImageFiles(for: selectedJob, customerKey: customer?.key)
            tableView.reloadData()
        }
    }
    
    // MARK: Header cell functions
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 285
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerCellId) as! CustomerHeaderCell
        customerHeaderCell = headerView
        customerHeaderCell?.registrationController = self
        // initalize customer to set up fields
        customerHeaderCell?.customer = customer
        return headerView

    }
    
    // MARK: TableView FLow Layout Function
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.5
    }
}

class CustomerHeaderCell: UITableViewHeaderFooterView {
    //MARK: Properties
    var customer: Customer? {
        didSet{
            // if customer is nil, then return because its a new customer with default values
            guard let customer = customer else { return }
            
            if let first = customer.first { firstNameField.text = first }
            if let middle = customer.middle  { middleNameField.text = middle }
            if let last = customer.last  { lastNameField.text = last }
            if let location = customer.location  { locationField.text = location }
            if let phone = customer.phone  { phoneField.text = phone }
            if let email = customer.email  { emailField.text = email }
            
            guard let privacy = customer.privacy else { return }
            privacySwitchControl.isOn = privacy
        }
    }
    
    var registrationController: CustomerRegistrationController?
    
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
        field.placeholder = "Last"
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
    
    let privacyLabel: UILabel = {
        let label = UILabel()
        label.text = "Privacy:"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let privacySubtitle: UILabel = {
        let label = UILabel()
        label.text = "Only shows name of customer when refered to others"
        label.numberOfLines = 2
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var privacySwitchControl: UISwitch = {
        let sc = UISwitch()
        sc.isOn = false
        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()
    
    let headerDividerLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        contentView.backgroundColor = UIColor(colorType: .background)
        
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
        addSubview(privacyLabel)
        addSubview(privacySubtitle)
        addSubview(privacySwitchControl)
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
        privacyLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        privacyLabel.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 8).isActive = true
        privacyLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/3).isActive = true
        
        // x, y, width and height constrants iOS - 9 above
        privacySubtitle.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        privacySubtitle.topAnchor.constraint(equalTo: privacyLabel.bottomAnchor, constant: 0).isActive = true
        privacySubtitle.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/2).isActive = true
        
        // x, y, width and height constrants iOS - 9 above
        privacySwitchControl.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        privacySwitchControl.topAnchor.constraint(equalTo: privacyLabel.topAnchor, constant: 8).isActive = true
        privacySwitchControl.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        // x, y, width and height constrants iOS - 9 above
        addJobButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        addJobButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        addJobButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        addJobButton.topAnchor.constraint(equalTo: privacySubtitle.bottomAnchor, constant: 8).isActive = true
        
        // x, y, width and height constrants iOS - 9 above
        headerDividerLine.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        headerDividerLine.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        headerDividerLine.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        headerDividerLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }
}
