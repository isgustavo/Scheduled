//
//  ScheduledViewController.swift
//  Scheduled
//
//  Created by Gustavo F Oliveira on 5/10/16.
//  Copyright © 2016 Gustavo F Oliveira. All rights reserved.
//

import UIKit

protocol ScheduledDataSource {
    
    func insert(newFlight newFlight: Flight)
    func update(flight flight: Flight)
    func requestUpdateData()
    
}

class ScheduledViewController: UIViewController, CardContainerDataSource, ScheduledDataSource {
    
    @IBOutlet weak var message: UILabel!
    
    private var flights: [Flight]! {
        didSet {
            self.container.reloadCardContainer()
        }
    }
    
    private var container: CardContainer!
    private let dateFormatter = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dateFormatter.dateFormat = "EE MMMM dd,  HH:mm"
        
        self.container = CardContainer()
        self.container.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.container.backgroundColor = UIColor.clearColor()
        self.container.dataSource = self

        self.view.addSubview(self.container)
        
        self.flights = FlightDAO.fetchAllFlight()
        
        self.message.text = "That's all!"
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapCardGesture(_:)))
        self.container.addGestureRecognizer(tapGesture)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Data Source
    func cardContainerViewNextViewWithIndex(index: Int) -> UIView {
        
        let card: Card = Card(frame: CGRect(x: 15, y: 70, width: self.view.frame.size.width - 30, height: self.view.frame.size.width * 1.35))
        
        let flight: Flight = self.flights[index]
        
        card.departureCity.text = flight.departureAirport?.cityName
        card.departureAirport.text = flight.departureAirport?.airportName
        
        card.arrivalAirport.text = flight.arrivalAirport?.airportName
        card.arrivalCity.text = flight.arrivalAirport?.cityName
        
        card.airline.text = flight.airline
        card.reservationCode.text = flight.reservationCode

        card.dataHour.text = self.dateFormatter.stringFromDate(flight.dateHour!)
        
        if flight.hotel?.name == nil {
           card.hotel.hidden = true
        }
        card.hotelName.text = flight.hotel?.name ?? " "
        card.address.text = flight.hotel?.address ?? " "
        card.phone.text = flight.hotel?.phone ?? " "
        
        return card
        
    }
    
    func cardContainerViewNumberOfViewInIndex() -> Int {
        return self.flights.count
    }
    
    @IBAction func refreshButtonTapped(sender: AnyObject) {
        
        self.requestUpdateData()
        
    }
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "newScheduledSegue" {
            let nvc = segue.destinationViewController as! NewTableViewController
            nvc.dataSource = self
        }
        
    }
    
    
    // MARK: - Scheduled Data Source
    
    func insert(newFlight newFlight: Flight) {
        
        FlightDAO.insert(newFlight)
        
    }
    
    func update(flight flight: Flight) {
        
        FlightDAO.update(flight)
    }
    
    func requestUpdateData() {
        
        self.flights = FlightDAO.fetchAllFlight()
    }
    
    // MARK: - 
    
    func tapCardGesture(recognizer: UITapGestureRecognizer) {
        
        if let _ = self.container.getCurrentView() {
            
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nvc = storyboard.instantiateViewControllerWithIdentifier("NewTableViewController") as! NewTableViewController
            nvc.update = true
            nvc.dataSource = self
            nvc.flight = self.flights[self.container.getCurrentIndex()]
            self.navigationController?.pushViewController(nvc, animated: true)
        }
        
        
    }
    
}
