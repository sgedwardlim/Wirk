//
//  CustomerController.swift
//  wirk
//
//  Created by Edward on 2/11/17.
//  Copyright © 2017 Edward. All rights reserved.
//

import UIKit

class CustomerController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {
    
    // MARK: Properties
    lazy var addCustomerButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddCustomerTapped))
        return button
    }()
    
    func handleAddCustomerTapped() {
        let cutomerRegistrationController = CustomerRegistrationController()
        let navController = UINavigationController(rootViewController: cutomerRegistrationController)
        present(navController, animated: true, completion: nil)
    }
    
    lazy var searchButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleSearchTapped))
        return button
    }()
    
    func handleSearchTapped() {
        searchController = UISearchController(searchResultsController: nil)
        definesPresentationContext = true
        searchController?.dimsBackgroundDuringPresentation = false
        searchController?.searchResultsUpdater = self
        searchController?.searchBar.delegate = self
        tableView.tableHeaderView = searchController?.searchBar
        searchController?.searchBar.becomeFirstResponder()
    }
    
    private let customerCellId = "customerCellId"
    var searchController: UISearchController?
    var customers: [Customer]?
    var filteredCustomers: [Customer]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView?.alwaysBounceVertical = true
        tableView?.backgroundColor = UIColor(colorType: .background)
        // This makes it so that it dosent show default empty cells
        tableView?.tableFooterView = UIView(frame: .zero)
        
        navigationItem.title = "Customers"
        navigationItem.rightBarButtonItems = [addCustomerButton, searchButton]
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
    
    // MARK: Search Controller
    @available(iOS 8.0, *)
    public func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text?.lowercased() else { return }
        filteredCustomers = customers?.filter({ (customer) -> Bool in
            // fields we want to search for
            let first = customer.first?.lowercased()
            let middle = customer.middle?.lowercased()
            let last = customer.last?.lowercased()
            let location = customer.location?.lowercased()
            let phone = customer.phone?.lowercased()
            
            return first!.contains(query) ||
                   middle!.contains(query) ||
                   last!.contains(query) ||
                   location!.contains(query) ||
                   phone!.contains(query)
        })
        
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.isHidden = true
        searchBar.isUserInteractionEnabled = false
        tableView.tableHeaderView = nil
    }
    
    // MARK: TableView Data Source Functions
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        // Checks if search field is being edited
        if searchController?.isActive != nil && searchController?.searchBar.text != "" {
            if let count = filteredCustomers?.count {
                return count
            }
        }
        // Display number of customers in a list
        else if let count = customers?.count {
            return count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Checks if search field is being edited
        if searchController?.isActive != nil && searchController?.searchBar.text != "" {
            let cell = tableView.dequeueReusableCell(withIdentifier: customerCellId, for: indexPath) as! CustomerCell
            cell.customer = filteredCustomers?[indexPath.item]
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: customerCellId, for: indexPath) as! CustomerCell
            cell.customer = customers?[indexPath.item]
            return cell
        }
    }
    
    // Present CustomerRegistrationController if one of the cells are selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Checks if search field is being edited
        if searchController?.isActive != nil && searchController?.searchBar.text != "" {
            if let selectedCustomer = filteredCustomers?[indexPath.item] {
                let view = CustomerRegistrationController()
                view.customer = selectedCustomer
                let nav = UINavigationController(rootViewController: view)
                present(nav, animated: true, completion: nil)
            }
        } else {
            // search field was not selected normal customer list was selected
            if let selectedCustomer = customers?[indexPath.item] {
                let view = CustomerRegistrationController()
                view.customer = selectedCustomer
                let nav = UINavigationController(rootViewController: view)
                present(nav, animated: true, completion: nil)
            }
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
            let customer: Customer?
            if searchController?.isActive != nil && searchController?.searchBar.text != "" {
                // remove value from filtered customers list
                customer = filteredCustomers?.remove(at: indexPath.item)
            } else {
                // remove value from unfiltered customers list
                customer = customers?.remove(at: indexPath.item)
            }
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



