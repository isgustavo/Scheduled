//
//   NewTableViewController.swift
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

protocol FlightLocationDelegate: class {
    
    func selectedLocation(airport: Airport, isAirportForDeparture: Bool)
    
}

protocol AirlineDelegate: class {
    
    func selectedAirline(airline: String)
}

class NewTableViewController: UITableViewController, FlightLocationDelegate, UITextFieldDelegate, AirlineDelegate {

    @IBOutlet weak var fromLocation: UILabel!
    var fromAirport: Airport?
    @IBOutlet weak var toLocation: UILabel!
    var toAirport: Airport?
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var reservationCode: UITextField!
    @IBOutlet weak var airline: UILabel!
    
    @IBOutlet weak var hotelName: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var phone: UITextField!
    
    var flight: Flight!
    var update: Bool = false
    var dataSource: ScheduledDataSource!
    
    private let dateFormatter = NSDateFormatter()
    private var datePickerHidden: Bool = true
    private var hotelHidden: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dateFormatter.dateFormat = "EE MMMM dd,  HH:mm"
        
        self.reservationCode.delegate = self
        self.hotelName.delegate = self
        self.address.delegate = self
        self.phone.delegate = self
        
        if self.update == true {
            
            self.fromLocation.text = self.flight.departureAirport?.airportName
            self.fromAirport = self.flight.departureAirport
            self.toLocation.text = self.flight.arrivalAirport?.airportName
            self.toAirport = self.flight.arrivalAirport
            self.reservationCode.text = self.flight.reservationCode
            self.airline.text = self.flight.airline
            
            if flight.hotel != nil {
                self.toggleHotel()
                self.hotelName.text = flight.hotel?.name
                self.address.text = flight.hotel?.address
                self.phone.text = flight.hotel?.phone
                
            }
            
        }
        
        self.tableView.tableFooterView = UIView()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view delegate

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 && indexPath.row == 1 {
            toggleDatepicker()
        } else {
            hiddenDatepiker()
        }
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if self.datePickerHidden && indexPath.section == 0 && indexPath.row == 2 {
            return 0
        }
        else if self.hotelHidden && indexPath.section == 4 && indexPath.row > 0 {
            return 0
        } else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }

    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        // This changes the header background
        view.tintColor = UIColor(red: CGFloat(64.0/255), green: CGFloat(64.0/255), blue: CGFloat(85.0/255), alpha: CGFloat(0.0))
        
        // Gets the header view as a UITableViewHeaderFooterView and changes the text colour
        let headerView: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        headerView.textLabel?.textColor = UIColor(red: CGFloat(64.0/255), green: CGFloat(64.0/255), blue: CGFloat(85.0/255), alpha: CGFloat(1.0))
        headerView.textLabel?.font = UIFont (name: "HelveticaNeue-Medium", size: 15)
        
    }
    
    override func tableView(tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        
        // This changes the header background
        view.tintColor = UIColor(red: CGFloat(64.0/255), green: CGFloat(64.0/255), blue: CGFloat(85.0/255), alpha: CGFloat(0.3))
        
        // Gets the header view as a UITableViewHeaderFooterView and changes the text colour
        //let headerView: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        //headerView.textLabel?.textColor = UIColor(red: CGFloat(64.0/255), green: CGFloat(64.0/255), blue: CGFloat(85.0/255), alpha: CGFloat(1.0))
        //headerView.textLabel?.font = UIFont (name: "HelveticaNeue-Light", size: 20)
        
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "airlineSegue" {
            let dv = segue.destinationViewController as! AirlineTableViewController
            dv.delegate = self
            
        } else {
            let dv = segue.destinationViewController as! AirportTableViewController
            dv.delegate = self
            if segue.identifier == "fromSegue" {
                 dv.departure = true
            } else {
                dv.departure = false
            }
        }
        
    }
    
    // MARK: - UI Text Field Delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Flight Location Delegate
    
    func selectedLocation(airport: Airport, isAirportForDeparture departure: Bool) {
        
        if departure {
            self.fromLocation.text = airport.airportName
            self.fromAirport = airport
        } else {
            self.toLocation.text = airport.airportName
            self.toAirport = airport
        }
        
    }
    
    // MARK: - Airline Delegate
    
    func selectedAirline(airline: String) {
        
        self.airline.text = airline
        
    }
    
    // MARK: - Action buttons
    
    @IBAction func done(sender: AnyObject) {
        
        if verifyValues() == false {
            showWarningMessage()
            return
        }

        if update == false {
            
            let flight = Flight()
            flight.departureAirport = self.fromAirport
            flight.arrivalAirport = self.toAirport
            flight.airline = self.airline.text
            flight.dateHour = self.datePicker.date
            flight.reservationCode = self.reservationCode.text
            
            if self.hotelHidden == false  {
                flight.hotel = Hotel()
                flight.hotel?.name = self.hotelName.text
                flight.hotel?.phone = self.phone.text
                flight.hotel?.address = self.address.text
            }
            
            self.dataSource.insert(newFlight: flight)
            
        } else {
            
            self.flight.departureAirport = self.fromAirport
            self.flight.arrivalAirport = self.toAirport
            self.flight.airline = self.airline.text
            self.flight.dateHour = self.datePicker.date
            self.flight.reservationCode = self.reservationCode.text
            
            if self.hotelHidden == false  {
                self.flight.hotel?.name = self.hotelName.text
                self.flight.hotel?.phone = self.phone.text
                self.flight.hotel?.address = self.address.text
            } else {
                self.flight.hotel = nil
            }
            
            self.dataSource.update(flight: self.flight)
        }

        self.dataSource.requestUpdateData()
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    func verifyValues() -> Bool {
        
        if self.airline.text == "" { return false }
        if self.reservationCode.text == "" { return false }
        if self.fromAirport == nil { return false }
        if self.toAirport == nil { return false }
        
        
        if self.hotelHidden == false {
            
            if self.hotelName.text == "" { return false }
            if self.address.text == "" { return false }
            if self.phone.text == "" { return false }
            
        }
        
        return true
        
    }
    
    func showWarningMessage(){
        
        // create the alert
        let alert = UIAlertController(title: "Done?", message: "You must fill in all fields before the Done button.", preferredStyle: UIAlertControllerStyle.Alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        
        // show the alert
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func valueChanged(sender: AnyObject) {
        
        let date: NSDate = self.datePicker.date
        
        self.date.text = self.dateFormatter.stringFromDate(date)
        
        
    }
    
    @IBAction func addHotel(sender: AnyObject) {
        self.toggleHotel()

    }

    @IBAction func flightCodeChanged(sender: AnyObject) {
        
        self.reservationCode.text = self.reservationCode.text?.uppercaseString
        
    }

    @IBAction func hotelNameChanged(sender: AnyObject) {
        
        self.hotelName.text = self.hotelName.text?.uppercaseString
        
    }
    
    @IBAction func addressChanged(sender: AnyObject) {
        
        self.address.text = self.address.text?.uppercaseString
    }
    
    @IBAction func phoneChanged(sender: AnyObject) {
        
        let count:Int = (self.phone.text?.characters.count)!
        
        if count == 1 {
            self.phone.text? = "(\(self.phone.text!)"
            return
        } else if count == 3 {
            self.phone.text? = "\(self.phone.text!)) "
            return
        } else if count == 9 {
            self.phone.text? = "\(self.phone.text!) "
            return
        }
        
    }
    
    func toggleHotel() {
        
        self.hotelHidden = !hotelHidden
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func toggleDatepicker() {
        
        self.datePickerHidden = !datePickerHidden
        
        tableView.beginUpdates()
        tableView.deselectRowAtIndexPath(tableView.indexPathForSelectedRow!, animated: true)
        tableView.endUpdates()
        
    }
    
    func hiddenDatepiker() {
        
        self.datePickerHidden = true
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    

}
