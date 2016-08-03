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
import ChameleonFramework
import GoogleAPIClient
import GTMOAuth2

class TableViewPageController: UIViewController{
    var myArticles = [JSON]() ?? []
//    var titlesString = [String]()
    var myString = [JSON]() ?? []
    var myVar = [JSON]() ?? []
    @IBOutlet weak var myCoolLabel: UITextView!
@IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var connectCalendarButotn: UIButton!
    @IBOutlet weak var myTextView: UITextView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var calendarNameView: UIView!
    @IBOutlet weak var calendarNameLabel: UILabel!
    @IBOutlet weak var titlesString: UITextView!
    //Google Cal
    private let kKeychainItemName = "Google Calendar API"
    private let kClientID = "973148780218-c56k2gq4a0riejfiok2eun5ffrerja82.apps.googleusercontent.com"
    
    // If modifying these scopes, delete your previously saved credentials by
    // resetting the iOS simulator or uninstall the app.
    private let scopes = [kGTLAuthScopeCalendarReadonly]
    
    private let service = GTLServiceCalendar()
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        view.addSubview(myCoolLabel);
        //Calls on name and client ID for Google Cal again
        if let auth = GTMOAuth2ViewControllerTouch.authForGoogleFromKeychainForName(
            kKeychainItemName,
            clientID: kClientID,
            clientSecret: nil) {
            service.authorizer = auth
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
    
    @IBAction func connectCalendarButtonPressed(sender:AnyObject) {
        
        if let authorizer = service.authorizer,
            canAuth = authorizer.canAuthorize where canAuth {
            connectCalendarButton.hidden = true
            fetchEvents()
            
        } else {
            presentViewController(
                createAuthController(),
                animated: true,
                completion: nil
            )
           
        }
    }
    //This just makes sure that the label that says calendar is hidden if the user isn't logged in to Google.
    override func viewDidAppear(animated: Bool) {
        if let authorizer = service.authorizer,
            canAuth = authorizer.canAuthorize where canAuth {
            fetchEvents()
        }
        else{
        }
    
        
        // Construct a query and get a list of upcoming events from the user calendar
        func fetchEvents() {
            let query = GTLQueryCalendar.queryForEventsListWithCalendarId("primary")
            query.maxResults = 10
            query.timeMin = GTLDateTime(date: NSDate(), timeZone: NSTimeZone.localTimeZone())
            query.singleEvents = true
            query.orderBy = kGTLCalendarOrderByStartTime
            service.executeQuery(
                query,
                delegate: self,
                didFinishSelector: "displayResultWithTicket:finishedWithObject:error:"
            )
        }
        
        // Display the start dates and event summaries in the UITextView
        func displayResultWithTicket(
            ticket: GTLServiceTicket,
            finishedWithObject response : GTLCalendarEvents,
                               error : NSError?) {
            
            if let error = error {
                showAlert("Error", message: error.localizedDescription)
                return
            }
            
            var eventString = ""
            
            if let events = response.items() where !events.isEmpty {
                for event in events as! [GTLCalendarEvent] {
                    let start : GTLDateTime! = event.start.dateTime ?? event.start.date
                    let startString = NSDateFormatter.localizedStringFromDate(
                        start.date,
                        dateStyle: .ShortStyle,
                        timeStyle: .ShortStyle
                    )
                    eventString += "\(event.summary) on \(startString)\n"
                    
                    
                }
            } else {
                eventString = "No upcoming events found."
            }
            
            myCoolLabel.text = eventString
            connectCalendarButton.hidden = true
        }
        
        
        // Creates the auth controller for authorizing access to Google Calendar API
        private func createAuthController() -> GTMOAuth2ViewControllerTouch {
            let scopeString = scopes.joinWithSeparator(" ")
            return GTMOAuth2ViewControllerTouch(
                scope: scopeString,
                clientID: kClientID,
                clientSecret: nil,
                keychainItemName: kKeychainItemName,
                delegate: self,
                finishedSelector: "viewController:finishedWithAuth:error:"
            )
        }
        
        // Handle completion of the authorization process, and update the Google Calendar API
        // with the new credentials.
        func viewController(vc : UIViewController,
                            finishedWithAuth authResult : GTMOAuth2Authentication, error : NSError?) {
            
            if let error = error {
                service.authorizer = nil
                showAlert("Authentication Error", message: error.localizedDescription)
                return
            }
            
            service.authorizer = authResult
            dismissViewControllerAnimated(true, completion: nil)
        }
        
        // Helper for showing an alert
        func showAlert(title : String, message: String) {
            let alert = UIAlertController(
                title: title,
                message: message,
                preferredStyle: UIAlertControllerStyle.Alert
            )
            let ok = UIAlertAction(
                title: "OK",
                style: UIAlertActionStyle.Default,
                handler: nil
            )
            alert.addAction(ok)
            presentViewController(alert, animated: true, completion: nil)
        }
        

}
