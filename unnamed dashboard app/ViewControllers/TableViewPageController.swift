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
import ChameleonFramework
import EventKit
import EventKitUI

class TableViewPageController: UIViewController{
    var myArticles = [JSON]() ?? []
//    var titlesString = [String]()
    var myString = [JSON]() ?? []
    var myVar = [JSON]() ?? []
    var calendar: EKCalendar! // Passed in from previous view controller
    var events: [EKEvent]?
    @IBOutlet weak var myCoolLabel: UITextView!
    var services = ["Calendar", "Google News", "Weather", "Social Feed" ]
@IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var myTextView: UITextView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var calendarNameView: UIView!
    @IBOutlet weak var calendarNameLabel: UILabel!
    @IBOutlet weak var titlesString: UITextView!
    

        
    override func viewDidLoad() {
        super.viewDidLoad()
                loadEvents()
        for event in events! {
//            let title = article["title"].stringValue
            print("title \(event.title)")
            let textToAppend = event.title
            self.myCoolLabel.text = self.myCoolLabel.text.stringByAppendingString(textToAppend)
            
        }
        //Date start
        let currentDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.FullStyle
        var convertedDate = dateFormatter.stringFromDate(currentDate)
        dayLabel.text = convertedDate
        //Date end
        let colors:[UIColor] = [
      UIColor(red:0.95, green:0.77, blue:0.79, alpha:1.0), UIColor(red:0.52, green:0.67, blue:0.79, alpha:1.0)
        ]
        let background = GradientColor(.TopToBottom, frame: view.frame, colors: colors)
       view.backgroundColor = background
//        view.backgroundColor = FlatSkyBlue()
//         self.calendarNameLabel.font = UIFont(name: "Montserrat-Regular", size: 15)!
//        self.calendarNameView.layer.borderWidth = 2.5
//        self.calendarNameVi00ew.layer.borderColor = UIColor(red:0.07, green:0.00, blue:0.00, alpha:1.0).CGColor
//        secondView.backgroundColor = background
        EventStore.requestAccess() { (granted, error) in
            if granted {
                print("got permission")
            }
        }
    
    
//        let events = EventStore.getEvents(Month(year: 2016, month: 7)
                  }
   //     if events != nil {
//            for e in events {
//                myCoolLabel.text = ("Today you have \(e.title)")
//                print("startDate: \(e.startDate)")
//                print("endDate: \(e.endDate)")
//            
//        }
//        
//    }
//        else {
//            print("You have 0 events on your calendar today.")
//        }


    
    func loadEvents() {
        // Create a date formatter instance to use for converting a string to a date
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // Create start and end date NSDate instances to build a predicate for which events to select
        let startDate = dateFormatter.dateFromString("2016-06-26")
        let endDate = dateFormatter.dateFromString("2016-6-27")
        
        if let startDate = startDate, endDate = endDate {
            let eventStore = EKEventStore()
            
            // Use an event store instance to create and properly configure an NSPredicate
            let eventsPredicate = eventStore.predicateForEventsWithStartDate(startDate, endDate: endDate, calendars: [calendar])
            
            // Use the configured NSPredicate to find and return events in the store that match
            self.events = eventStore.eventsMatchingPredicate(eventsPredicate).sort(){
                (e1: EKEvent, e2: EKEvent) -> Bool in
                return e1.startDate.compare(e2.startDate) == NSComparisonResult.OrderedAscending
            }
            
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
        let url = "https://newsapi.org/v1/articles"
        let params = [ "source" : "thenewyorktimes" ,
                       "sortBy" : "popular" ,
                       "apiKey" : "76bf0e6c09c846fcae1484659167aa91"]
        myArticles = [JSON]()
        Alamofire.request(.GET, url, parameters: params).responseJSON { response in
            switch response.result {
            case .Success(let data):
                let json = JSON(data)
                self.myArticles = json["articles"].arrayValue
                var myVar = self.myArticles[0..<1]
//                var firstFive = self.myArticles.stringValue[0..<5]
//            myTextView.text = firstFive
                for article in myVar {
                    let title = article["title"].stringValue
                    print("title \(title)")
                    let textToAppend = title
                self.titlesString.text = self.titlesString.text.stringByAppendingString(textToAppend)
                    
                }
//                self.titlesString.reloadData()
                //The titles are displayed on success
            //                self.newsTextView.text = ("\(self.titlesString)\n\n")
            case .Failure(let error):
                //An error printed on failure
                print("Could not connect \(error)")
            }
        }
        
        
    }
    

}

//extension NSDate {
//    var dayAfter:NSDate {
//        let oneDay:Double = 60 * 60 * 24
//        return self.dateByAddingTimeInterval(oneDay)
//    }
//    var dayBefore:NSDate {
//        let oneDay:Double = 60 * 60 * 24
//        return self.dateByAddingTimeInterval(-(Double(oneDay)))
//    }
//}



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
