//
//  DashboardViewController.swift
//  unnamed dashboard
//
//  Created by Dylan Steck on 7/15/16.
//  Copyright © 2016 Dylan Steck. All rights reserved.
//

import Foundation
import UIKit
import GoogleAPIClient
import GTMOAuth2
import Alamofire
import SwiftyJSON
import ChameleonFramework
import CopperKit

class DashboardViewController: UIViewController{
    // IBOutlets for the output(where the Google Cal events go), the connectCalendarButton(where you connect your Google account for the API), the Calendar label(just a label for the calendar section), and a newsTextView(text view for the NewsAPI).
    var myArticles = [JSON]() ?? []
    var titlesString = [String]()
    @IBOutlet weak var topButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lifestyleButton: UIButton!
    @IBOutlet weak var socialButton: UIButton!
    @IBOutlet weak var utilitiesButton: UIButton!
    @IBOutlet weak var output: UITextView!
    @IBOutlet weak var connectCalendarButton: UIButton!
    @IBOutlet weak var calendarLabel: UILabel!
    //    @IBOutlet weak var newsTextView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    //These are necessary for the Google Calendar API( name and Client ID from the Google Developer Console).
    private let kKeychainItemName = "Google Calendar API"
    private let kClientID = "973148780218-c56k2gq4a0riejfiok2eun5ffrerja82.apps.googleusercontent.com"
    
    // If modifying these scopes, delete your previously saved credentials by
    // resetting the iOS simulator or uninstall the app.
    private let scopes = [kGTLAuthScopeCalendarReadonly]
    
    private let service = GTLServiceCalendar()
    
    var name: String?
    
    
    // When the view loads, create necessary subviews
    // and initialize the Google Calendar API service
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //All of this output stuff just sets size and features to the output for the Google Calendar API.
        //        self.output.frame = view.bounds
        self.output.editable = false
        self.output.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        self.output.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        // The let colors and view.backgroundColor are all for a gradient, which requires ChameleonFramework.
        let colors:[UIColor] = [
            UIColor(red:0.96, green:0.78, blue:0.81, alpha:1.0),
            UIColor(red:0.52, green:0.67, blue:0.79, alpha:1.0)
        ]
        let colorsForTextView: [UIColor] = [
            UIColor(red:0.96, green:0.78, blue:0.81, alpha:1.0)
        ]
        var background = GradientColor(.TopToBottom, frame: view.frame, colors: colors)
        var backgroundOther = GradientColor(.TopToBottom, frame: view.frame, colors: colorsForTextView)
        view.backgroundColor = background
        output.backgroundColor = backgroundOther
        //        Makes sure that the newsTextView isn't editable.
        //      newsTextView.editable = false
        
        
        
        
        view.addSubview(output);
        //Calls on name and client ID for Google Cal again
        if let auth = GTMOAuth2ViewControllerTouch.authForGoogleFromKeychainForName(
            kKeychainItemName,
            clientID: kClientID,
            clientSecret: nil) {
            service.authorizer = auth
        }
        
        //Parsing for newsAPI to get stories. There are many choices for the source parameter(bloomberg, google news, the list goes on an on at newsapi.org) and there are 3 options for sortBy(top, latest, featured).
        
        //Alamofire is used to parse the data and a for statement grabs the titles and put its in the newsTextView
        
        //fonts  and styling
        //        self.topButton.titleLabel!.font = UIFont(name: "Montserrat-Regular", size: 15)!
        //        self.lifestyleButton.titleLabel!.font = UIFont(name: "Montserrat-Regular", size: 15)!
        //        self.socialButton.titleLabel!.font = UIFont(name: "Montserrat-Regular", size: 15)!
        //        self.utilitiesButton.titleLabel!.font = UIFont(name: "Montserrat-Regular", size: 15)!
        ////         self.topButton.titleLabel!.textColor = UIColor.flatWatermelonColor()
        
        
        
        //end fonts and styling
        
        
        
        
    }
    
    
    
    // If the user hasn't logged into Google yet, the connectCalendarButton will prompt the sign in and after-so display the events. If not, the button is hidden and the events are displayed.
    @IBAction func connectCalendarButtonPressed(sender:AnyObject) {
        
        if let authorizer = service.authorizer,
            canAuth = authorizer.canAuthorize where canAuth {
            connectCalendarButton.hidden = true
            calendarLabel.hidden = false
            fetchEvents()
            
        } else {
            presentViewController(
                createAuthController(),
                animated: true,
                completion: nil
            )
            calendarLabel.hidden = true
        }
    }
    //This just makes sure that the label that says calendar is hidden if the user isn't logged in to Google.
    override func viewDidAppear(animated: Bool) {
        if let authorizer = service.authorizer,
            canAuth = authorizer.canAuthorize where canAuth {
            fetchEvents()
            calendarLabel.hidden = false
        }
        else{
            calendarLabel.hidden = true
        }
        
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
                
                for article in self.myArticles {
                    let title = article["title"].stringValue
                    self.titlesString.append(title)
                    
                }
                self.tableView.reloadData()
                //The titles are displayed on success
            //                self.newsTextView.text = ("\(self.titlesString)\n\n")
            case .Failure(let error):
                //An error printed on failure
                print("Could not connect \(error)")
            }
        }
        
        
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
        
        output.text = eventString
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        nameLabel.text = "Hello, \(name!)!"
    }
    
    
}

extension DashboardViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myArticles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! NewsTableViewCell
        cell.tableViewLabel?.text = titlesString[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
}