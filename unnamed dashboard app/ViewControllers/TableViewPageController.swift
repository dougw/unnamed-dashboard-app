//
//  TableViewPageController.swift
//  WebDeck
//
//  Created by Dylan Steck on 8/1/16.
//  Copyright © 2016 WebDeck. All rights reserved.
//
import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import TTEventKit

class TableViewPageController: UIViewController, UITableViewDelegate, UITableViewDataSource{
        @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        EventStore.requestAccess() { (granted, error) in
            if granted {
                println("got permission")
            }
        }
        
        
        let events = EventStore.getEvents(Month(year: 2015, month: 1))
        
        if events != nil {
            for e in events {
                println("Title \(e.title)")
                println("startDate: \(e.startDate)")
                println("endDate: \(e.endDate)")
            }
        }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath) as! DashboardTableViewCell
        cell.calendarTableViewLabel?.text = "Google Calendar"
       return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
}