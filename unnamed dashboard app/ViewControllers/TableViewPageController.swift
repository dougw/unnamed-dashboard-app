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
import EasyTimer
import TwitterKit

import Social
class TableViewPageController: UIViewController{
    @IBOutlet weak var myNameLabel: UILabel!
    var myArticles = [JSON]() ?? []
    //    var titlesString = [String]()
    var myString = [JSON]() ?? []
    var myVar = [JSON]() ?? []
    var calendar = EKCalendar(forEntityType: .Event, eventStore: EKEventStore()) // Passed in from previous view controller
    var events: [EKEvent]?
    var eventStore = EKEventStore()
    @IBOutlet weak var myCoolLabel: UITextView!
    var services = ["Calendar", "Google News", "Weather", "Social Feed" ]
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var timeLabel: UILabel!
    var name = ""
    @IBOutlet weak var myTextView: UITextView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var calendarNameView: UIView!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var calendarNameLabel: UILabel!
    @IBOutlet weak var titlesString: UITextView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myNameLabel.text = "Hello, "+name+"!"
        loadEvents()
//        for event in events! {
//            //            let title = article["title"].stringValue
//            print("title \(event.title)")
//            let textToAppend = event.title
//            self.myCoolLabel.text = self.myCoolLabel.text.stringByAppendingString(textToAppend)
//            
//        }
          //     Date start
       
        let currentDate = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEEE, MMM d, y"
        let dateObj = formatter.stringFromDate(currentDate)
        self.dayLabel.text = dateObj
//        1.second.interval {
//            let currentDate = NSDate()
//            let formatter = NSDateFormatter()
//            formatter.dateFormat = "h:mm:ss a"
//            let dateObj = formatter.stringFromDate(currentDate)
//            self.timeLabel.text = dateObj
//            print(dateObj)
//            
//        }

     //   Date end
        let colors:[UIColor] = [
            UIColor(red:0.95, green:0.77, blue:0.79, alpha:1.0), UIColor(red:0.52, green:0.67, blue:0.79, alpha:1.0)
        ]
        let background = GradientColor(.TopToBottom, frame: view.frame, colors: colors)
        view.backgroundColor = background
        //FFFFFF
        //alpha .2
        
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
        
        
    }
    
    
    
    func loadEvents() {
        // Get the appropriate calendar
        var calendar: NSCalendar = NSCalendar.currentCalendar()
        // Create the start date components
        var oneDayAgoComponents: NSDateComponents = NSDateComponents()
        oneDayAgoComponents.day = 0
        var oneDayAgo: NSDate! = calendar.dateByAddingComponents(oneDayAgoComponents, toDate: NSDate(), options: [])
        // Create the end date components
//        var oneYearFromNowComponents: NSDateComponents = NSDateComponents()
//        oneYearFromNowComponents.day = 0
//        var oneYearFromNow: NSDate! = calendar.dateByAddingComponents(oneYearFromNowComponents, toDate: NSDate(), options: [])
        // Create the predicate from the event store's instance method
        var predicate: NSPredicate = eventStore.predicateForEventsWithStartDate(oneDayAgo, endDate: oneDayAgo, calendars: nil)
        // Fetch all events that match the predicate
        var events: [AnyObject] = eventStore.eventsMatchingPredicate(predicate)
  
        if events.isEmpty == true {
            myCoolLabel.text = "You have no events today."
            print("You have no events today.")
        }
        else {
            print(events)
        for event in events {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE, MMM d, y h:mm a"
            let dateObj = formatter.stringFromDate(event.startDate)
            let textToAppend = ("\(event.title!) at \(dateObj)") + "\r\n"
            self.myCoolLabel.text = self.myCoolLabel.text.stringByAppendingString(textToAppend)
        }
        
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
        let url = "https://newsapi.org/v1/articles"
        let params = [ "source" : "googlenews" ,
                       "sortBy" : "top" ,
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

    //// Swift
    // Users must be logged-in to compose Tweets
    @IBAction func twitterButtonTapped(sender: AnyObject) {
//        if let session = Twitter.sharedInstance().sessionStore.session() {
//            
//            // User generated image
//            let image = UIImage()
//            
//            // Create the card and composer
//            let card = TWTRCardConfiguration.appCardConfigurationWithPromoImage(image, iPhoneAppID: "12345", iPadAppID: nil, googlePlayAppID: nil)
//            let composer = TWTRComposerViewController(userID: session.userID, cardConfiguration: card)
//            
//            // Optionally set yourself as the delegate
////            composer.delegate = self
//            
//            // Show the view controller
//            presentViewController(composer, animated: true, completion: nil)
//        }
        // Swift
        let composer = TWTRComposer()
        
        composer.setText("")
        composer.setImage(UIImage(named: "fabric"))
        
        // Called from a UIViewController
        composer.showFromViewController(self) { result in
            if (result == TWTRComposerResult.Cancelled) {
                print("Tweet composition cancelled")
            }
            else {
                print("Sending tweet!")
                let alertController = UIAlertController(title: "Twitter", message: "Your tweet has sent!", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
                    print("OK")
                }
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
   
    
    
}