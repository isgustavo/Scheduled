//
//   AirportTableViewController.swift
//   Scheduled
//
//   Created by Gustavo F Oliveira on 4/22/16.
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.

import UIKit

class AirportTableViewController: UITableViewController,/* UISearchControllerDelegate, UISearchResultsUpdating,*/ UISearchBarDelegate {
   
    private var searchController: UISearchController!
    
    private var filteredAirports: [Airport] = [Airport]()
    private var airports: [Airport] = [Airport]()
    
    var delegate: FlightLocationDelegate!
    
    var departure: Bool!
    
    var searchActive : Bool = false
    
    // MARK: - App cyclelife
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let background = UIImage(named: "Blue-Sky")
        //let imageView = UIImageView(image: background)
        //imageView.contentMode = UIViewContentMode.ScaleAspectFill
        
        //let blurEffect = UIBlurEffect(style: .Light)
        //let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        //blurredEffectView.frame = view.bounds
        //imageView.addSubview(blurredEffectView)
        
        //self.tableView.backgroundView = imageView
        
        self.airports = AirportDAO.fetchAll()
        self.filteredAirports = self.airports
        
        self.searchController = UISearchController(searchResultsController: nil)
        
        /*
        self.searchController.searchResultsUpdater = self
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        
        self.searchController.searchBar.placeholder = "Airport's city"
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = true
        
        self.navigationItem.titleView = searchController.searchBar
        */
        
        let search = UISearchBar()
        search.delegate = self
        self.navigationItem.titleView = search
        
        self.definesPresentationContext = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredAirports = airports.filter({ (text) -> Bool in
            let tmp: NSString = text.cityName!
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        if(filteredAirports.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filteredAirports.count
        }
        return airports.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let row = indexPath.row
        let airport:Airport
        if(searchActive){
            airport = self.filteredAirports[row]
        } else {
            airport = self.airports[row]
        }
        
        var cell: UITableViewCell!
        if row % 2 == 0 {
            cell  = tableView.dequeueReusableCellWithIdentifier("airportLightCell", forIndexPath: indexPath)
        }else {
             cell  = tableView.dequeueReusableCellWithIdentifier("airportDarkCell", forIndexPath: indexPath)
        }
        
        cell.textLabel?.text = airport.airportName
        cell.detailTextLabel?.text = airport.cityName
        
        return cell
    }
    
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        /*let airport: Airport = self.filteredAirports[indexPath.row]
        
        self.delegate.selectedLocation(airport, isAirportForDeparture: departure)
        
        self.navigationController?.popViewControllerAnimated(true)*/
        
        let airport: Airport
        
        if(searchActive){
            airport = self.filteredAirports[indexPath.row]
            //print(filteredAirports[indexPath.row].airportName)
        } else {
            airport = self.airports[indexPath.row]
            //print(airports[indexPath.row].airportName)
        }
        
        self.delegate.selectedLocation(airport, isAirportForDeparture: departure)
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(50.0)
    }

    // MARK: - Search Results Updating
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let sb = searchController.searchBar
        let target = sb.text!
        
        if target == "" {
            self.filteredAirports = self.airports
            return
        }
        
        self.filteredAirports = self.airports.filter {
            s in
            let options = NSStringCompareOptions.CaseInsensitiveSearch
            let found = s.cityName?.rangeOfString(target, options: options)
            return (found != nil)
        }
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            // do some task
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }
        
    }

}
