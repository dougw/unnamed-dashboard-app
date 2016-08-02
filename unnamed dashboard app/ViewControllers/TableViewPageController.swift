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
import ChameleonFramework

class TableViewPageController: UIViewController{
    @IBOutlet weak var myCoolLabel: UILabel!
    var services = ["Calendar", "Google News", "Weather", "Social Feed" ]
@IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var secondView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let colors:[UIColor] = [
           UIColor(red:0.00, green:0.82, blue:0.62, alpha:1.0), UIColor(red:0.08, green:0.13, blue:0.39, alpha:1.0)
        ]
        let background = GradientColor(.TopToBottom, frame: view.frame, colors: colors)
           view.backgroundColor = background
        secondView.backgroundColor = background
        EventStore.requestAccess() { (granted, error) in
            if granted {
                print("got permission")
            }
        }
    
    
        let events = EventStore.getEvents(Month(year: 2016, month: 6))
        
        if events != nil {
            for e in events {
//                myCoolLabel.text = e.title
                print("startDate: \(e.startDate)")
                print("endDate: \(e.endDate)")
            
        }
        
    }
        else {
            print("You have 0 events on your calendar today.")
        }
    }
}


    
    
    
//extension TableViewPageController: UITableViewDataSource, UITableViewDelegate {
//     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        
//        return services.count
//    }
//    
//     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath) as! DashboardTableViewCell
//        //make e.title the calendar table view label
//        cell.calendarTableViewLabel?.text = services[indexPath.row]
//        return cell
//    }
//    
//     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//    }
//    
//    
//    
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//}
