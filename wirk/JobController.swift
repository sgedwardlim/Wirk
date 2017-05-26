//
//  JobController.swift
//  wirk
//
//  Created by Edward on 2/25/17.
//  Copyright © 2017 Edward. All rights reserved.
//

import UIKit
import CoreLocation

enum SearchBarScopeTitles: String {
    case all = "Job Details"
    case dist = "Distance From"
    case city = "City or Zip"
    case error = "ERROR: Scope title string not found"
    
    static func type(_ scope: String) -> SearchBarScopeTitles {
        switch scope {
        case SearchBarScopeTitles.all.rawValue:
            return SearchBarScopeTitles.all
        case  SearchBarScopeTitles.dist.rawValue:
            return SearchBarScopeTitles.dist
        case  SearchBarScopeTitles.city.rawValue:
            return SearchBarScopeTitles.city
        default:
            return .error
        }
    }
}

class JobController: UITableViewController, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    // MARK: Properties
    lazy var searchButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleSearch))
        return button
    }()
    
    func handleSearch() {
        searchController = UISearchController(searchResultsController: nil)
        definesPresentationContext = true
        let scopes = SearchBarScopeTitles.self
        searchController?.searchBar.scopeButtonTitles = [scopes.all.rawValue, scopes.city.rawValue]
        searchController?.dimsBackgroundDuringPresentation = false
        searchController?.searchResultsUpdater = self
        searchController?.searchBar.delegate = self
        tableView.tableHeaderView = searchController?.searchBar
        searchController?.searchBar.becomeFirstResponder()
    }
    
    fileprivate let cellId = "cellId"
    var searchController: UISearchController?
    var jobs: [Job]?
    var filteredJobs: [Job]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(colorType: .background)
        // This makes it so that it dosent show default empty cells
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(JobCell.self, forCellReuseIdentifier: cellId)
        // Needed for iPad displays so that tableview seperator line extends full width
        tableView.cellLayoutMarginsFollowReadableWidth = false
        
        navigationItem.title = "Jobs"
        navigationItem.rightBarButtonItem = searchButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        System.sharedInstance.observeJobsDatabase { (jobs) in
            self.jobs = jobs
            self.tableView.reloadData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        System.jobRef.removeAllObservers()
    }
    
    // MARK: Search Controller Delegates
    @available(iOS 8.0, *)
    public func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let scope = searchController.searchBar.scopeButtonTitles?[searchBar.selectedScopeButtonIndex] else { return }
        guard let query = searchController.searchBar.text?.lowercased() else { return }
        filterContentFor(query: query, scope: SearchBarScopeTitles.type(scope))
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        guard let scopeTitle = searchBar.scopeButtonTitles?[selectedScope] else { return }
        let selectedScope = SearchBarScopeTitles.type(scopeTitle)
        filterPlaceholderFor(searchBar: searchBar, scope: selectedScope)
    }
    
    func filterContentFor(query: String, scope: SearchBarScopeTitles) {
        filteredJobs = jobs?.filter { job in
            
            switch scope {
            case .all:
                // Go through all properties of job field
                let jobType = job.jobType?.lowercased() ?? ""
                let jobDesciption = job.jobDescription?.lowercased() ?? ""
                return jobType.contains(query) || jobDesciption.contains(query)
            case .city:
                // Check the job fields if the city or zip fields are matching
                let city = job.city?.lowercased() ?? ""
                let zip = job.zip?.lowercased() ?? ""
                return city.contains(query) || zip.contains(query)
            default:
                return false
            }
        }
        tableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.isHidden = true
        searchBar.isUserInteractionEnabled = false
        tableView.tableHeaderView = nil
    }
    
    // MARK: Location Queries
    
    func filterPlaceholderFor(searchBar: UISearchBar, scope: SearchBarScopeTitles) {
        
        switch scope {
        case .all:
//            searchBar.becomeFirstResponder()
            searchBar.placeholder = "Search Job Details"
            break
        case .city:
//            searchBar.resignFirstResponder()
            searchBar.placeholder = "Enter a City or Zip Code"
            break
        default:
            break
        }
    }
    
    // MARK: TableView DataSource
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        // create the share button when user swipes left on a cell
        let share = UITableViewRowAction(style: .normal, title: "Add to list") { (action, index) in
            // get the job the user selected
            var job: Job?
            if self.searchController?.isActive != nil && self.searchController?.searchBar.text != "" {
                // user is filtering searches
                job = self.filteredJobs?[indexPath.row]
            } else {
                job = self.jobs?[indexPath.row]
            }
            guard let unwrappedJob = job else { return }
            SelectedJobs.shared.jobs.insert(unwrappedJob, at: 0)
            
            var currBadgeValue = self.tabBarController?.tabBar.items?[2].badgeValue
            if currBadgeValue == nil {
                currBadgeValue = "1"
            } else {
                currBadgeValue = String(Int(currBadgeValue!)! + 1)
            }
            self.tabBarController?.tabBar.items?[2].badgeValue = currBadgeValue
            self.jobs!.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        // Make background color of action green
        share.backgroundColor = UIColor(netHex: 0x10DDC2)
        
        return [share]
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController?.isActive != nil && searchController?.searchBar.text != "" {
            if let count = filteredJobs?.count {
                return count
            }
        }
        else if let count = jobs?.count {
            return count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if searchController?.isActive != nil && searchController?.searchBar.text != "" {
            if let selectedJob = filteredJobs?[indexPath.row] {
                let jobRegistrationView = JobRegistrationController()
                jobRegistrationView.job = selectedJob
                let nav = UINavigationController(rootViewController: jobRegistrationView)
                present(nav, animated: true, completion: nil)
            }
        } else {
            // search field was not selected normal jobs list was selected
            if let selectedJob = jobs?[indexPath.row] {
                let jobRegistrationView = JobRegistrationController()
                jobRegistrationView.job = selectedJob
                let nav = UINavigationController(rootViewController: jobRegistrationView)
                present(nav, animated: true, completion: nil)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if searchController?.isActive != nil && searchController?.searchBar.text != "" {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! JobCell
            cell.job = filteredJobs?[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! JobCell
            let job = jobs?[indexPath.row]
            cell.job = job
            cell.jobLocationLabel.text = job?.location
//            cell.distFromLabel.text = "10.0 mi"
//            LocationManager.getCityAndZip(with: job?.placemark, completion: { (city, zip) in
//                
//                cell.jobLocationLabel.text = String(format: "%@, %@", city ?? "", zip ?? "")
//            })
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 164
    }
}








