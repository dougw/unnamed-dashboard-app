//
//  TableViewPageController.swift
//  WebDeck
//
//  Created by Dylan Steck on 8/1/16.
//  Copyright © 2016 WebDeck. All rights reserved.
//
import Foundation
import UIKit
//import Alamofire
//import SwiftyJSON
import TTEventKit

class TableViewPageController: UIViewController{
    
@IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EventStore.requestAccess() { (granted, error) in
            if granted {
                print("got permission")
            }
        }
        
        
        let events = EventStore.getEvents(Month(year: 2016, month: 8))
        
        if events != nil {
            for e in events {
                print("Title \(e.title)")
                print("startDate: \(e.startDate)")
                print("endDate: \(e.endDate)")
            }
        }
        
    }
}

        
    
    
    
extension TableViewPageController: UITableViewDataSource, UITableViewDelegate {
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath) as! DashboardTableViewCell
        //make e.title the calendar table view label
        cell.calendarTableViewLabel?.text = "Google Calendar"
        return cell
    }
    
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}