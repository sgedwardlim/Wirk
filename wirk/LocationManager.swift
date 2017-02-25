//
//  LocationManager.swift
//  wirk
//
//  Created by Edward on 2/20/17.
//  Copyright © 2017 Edward. All rights reserved.
//

import UIKit
import MapKit

class LocationManager: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating, CLLocationManagerDelegate, UISearchControllerDelegate {
    
    // MARK: Properties
    lazy var cancelButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        return button
    }()
    
    func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        self.definesPresentationContext = true
        controller.dimsBackgroundDuringPresentation = false
        controller.searchResultsUpdater = self
        controller.hidesNavigationBarDuringPresentation = false
        return controller
    }()
    
    lazy var locationMananger: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        return manager
    }()
    
    private let cellId = "cellId"
    
    var currentLocation: MKMapItem?
    var filteredLocations: [MKMapItem]?
    var customerRegistrationHeader: CustomerHeaderCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Location"
        navigationItem.leftBarButtonItem = cancelButton
        tableView.tableHeaderView = searchController.searchBar
        
        locationMananger.requestLocation()
    }
    
    // MARK: Search Controller Delegate Functions
    @available(iOS 8.0, *)
    public func updateSearchResults(for searchController: UISearchController) {
        guard let searchBarText = searchController.searchBar.text else { return }
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchBarText
        let search = MKLocalSearch(request: request)
        search.start(completionHandler: { (response, _) in
            guard let response = response else { return }
            self.filteredLocations = response.mapItems
            if let currentLocation = self.currentLocation {
                self.filteredLocations?.insert(currentLocation, at: 0)
            }
            self.tableView.reloadData()
        })
    }
    
    
    // MARK: CLLocationManager Functions
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.requestLocation()
        }
    }
    
    /*
     *  Gets the current location of the user and inserts it into the begining of the
     *  filteredLocations array
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let coordinates = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            reverseGeocoding(coordinates: coordinates, completion: { (currentLocation) in
                self.currentLocation = currentLocation
                let locations = [currentLocation]
                self.filteredLocations = locations
                self.tableView.reloadData()
            })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    /*
     *  Pass in a set of coordinates, lat and long initalized with CLLocation
     *  when the asynchronus call is complete return a MKMapItem into
     *  the completion handler, callee checks if it is empty
     */
    private func reverseGeocoding(coordinates: CLLocation, completion: @escaping (MKMapItem) -> ()) {
        CLGeocoder().reverseGeocodeLocation(coordinates, completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                print(error!)
                return
            }
            
            guard let placemarks = placemarks else { return }
            
            if let pm = placemarks.first {
                let currentLocation = MKPlacemark(placemark: pm)
                let mapItem = MKMapItem(placemark: currentLocation)
                completion(mapItem)
            }
        })
    }
    
    func parseAddress(selectedItem: MKPlacemark) -> String {
        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        // put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        return addressLine
    }
    
    // MARK: TableView DataSource Functions
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = filteredLocations?.count {
            return count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        if let location = filteredLocations?[indexPath.item].placemark {
            if location.name == self.currentLocation?.name {
                cell.textLabel?.text = "Current Location"
                cell.detailTextLabel?.text = parseAddress(selectedItem: location)
            } else {
                cell.textLabel?.text = location.name
                cell.detailTextLabel?.text = parseAddress(selectedItem: location)
            }
        }
        return cell
    }
    
    // When the cell is selected, pass the location "String" into the callee location field
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath)
        let location = selectedCell?.detailTextLabel?.text
        customerRegistrationHeader?.locationField.text = location
        dismiss(animated: true, completion: nil)
    }
}



