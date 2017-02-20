//
//  CustomerController.swift
//  wirk
//
//  Created by Edward on 2/11/17.
//  Copyright © 2017 Edward. All rights reserved.
//

import UIKit

class CustomerController: UITableViewController {
    
    // MARK: Properties
    lazy var addCustomerButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(handleAddCustomerTapped))
        return button
    }()
    
    func handleAddCustomerTapped() {
        let cutomerRegistrationController = CustomerRegistrationController()
        let navController = UINavigationController(rootViewController: cutomerRegistrationController)
        present(navController, animated: true, completion: nil)
    }
    
    private let customerCellId = "customerCellId"
    var customers: [Customer]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView?.alwaysBounceVertical = true
        tableView?.backgroundColor = UIColor(colorType: .background)
        // This makes it so that it dosent show default empty cells
        tableView?.tableFooterView = UIView(frame: .zero)
        
        navigationItem.title = "Customers"
        navigationItem.rightBarButtonItem = addCustomerButton
        tableView.register(CustomerCell.self, forCellReuseIdentifier: customerCellId)
        
        if System.uid == nil {
            System.sharedInstance.logoutUser()
            handleLogout()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        System.sharedInstance.observeCustomersDatabase { (customers) in
            self.customers = customers
            self.tableView?.reloadData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        System.sharedInstance.removeCustomersObserver()
    }
    
    // MARK: TableView Data Source Functions
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = customers?.count {
            return count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: customerCellId, for: indexPath) as! CustomerCell
        cell.customer = customers?[indexPath.item]
        return cell
    }
    
    // Present CustomerRegistrationController if one of the cells are selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedCustomer = customers?[indexPath.item] {
            let view = CustomerRegistrationController()
            view.customer = selectedCustomer
            let nav = UINavigationController(rootViewController: view)
            present(nav, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let customer = customers?.remove(at: indexPath.item)
            customer?.ref?.removeValue()
            // Fetch all the jobs that belong to the customer
            System.sharedInstance.observeJobsDatabase(customer: customer, completion: { (jobs) in
                customer?.jobs = jobs
                if let jobs = customer?.jobs {
                    // Iterate through all jobs that belong to customer and remove from DATABASE
                    for job in jobs {
                        job.ref?.removeValue()
                        System.sharedInstance.deleteImageFiles(for: job, customerKey: customer?.key)
                    }
                }
            })
            tableView.reloadData()
        }
    }
}

class CustomerCell: UITableViewCell {
    
    var customer: Customer? {
        didSet {
            guard let customer = customer else { return }
            
            // Store the fully concatnated name
            var fullName = ""
            if let first = customer.first { fullName += "\(first)" }
            // formated with a space before
            if let middle = customer.middle  { fullName += " \(middle)" }
            // formated with a space before
            if let last = customer.last  { fullName += " \(last)" }
            nameLabel.text = fullName
            locationLabel.text = customer.location

            if let date = customer.dateCreated {
                // Create the format for date display
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMMM dd, yyyy"
                dateLabel.text = dateFormatter.string(from: date)
            }
        }
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "MM:DD:YYYY"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        backgroundColor = UIColor(colorType: .background)
        
        addSubview(nameLabel)
        addSubview(locationLabel)
        addSubview(dateLabel)
        
        // x, y, width height constraints
        nameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        
        // x, y, width height constraints
        locationLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 14).isActive = true
        locationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4).isActive = true
        locationLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        
        // x, y, width height constraints
        dateLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 14).isActive = true
        dateLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 4).isActive = true
        dateLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        
        // Remove the gap that the default seperatior line given
        preservesSuperviewLayoutMargins = false
        separatorInset = UIEdgeInsets.zero
        layoutMargins = UIEdgeInsets.zero
    }
    
}



