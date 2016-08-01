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
import GoogleAPIClient
import GTMOAuth2

class TableViewPageController: UIViewController, UITableViewDelegate, UITableViewDataSource{
   @IBOutlet weak var output: UITextView!
    @IBOutlet weak var connectCalendarButton: UIButton!
   @IBOutlet weak var calendarLabel: UILabel!
//    var text = ["Hello", "text", "Dylan"]
    var myArticles = [JSON]() ?? []
    var titlesString = [String]()
        @IBOutlet weak var tableView: UITableView!
    //These are necessary for the Google Calendar API( name and Client ID from the Google Developer Console).
    private let kKeychainItemName = "Google Calendar API"
    private let kClientID = "973148780218-c56k2gq4a0riejfiok2eun5ffrerja82.apps.googleusercontent.com"
    
    // If modifying these scopes, delete your previously saved credentials by
    // resetting the iOS simulator or uninstall the app.
    private let scopes = [kGTLAuthScopeCalendarReadonly]
    
    private let service = GTLServiceCalendar()
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.output.editable = false
//        self.output.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
//        self.output.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
//        view.addSubview(output);
        //Calls on name and client ID for Google Cal again
        if let auth = GTMOAuth2ViewControllerTouch.authForGoogleFromKeychainForName(
            kKeychainItemName,
            clientID: kClientID,
            clientSecret: nil) {
            service.authorizer = auth
        }

    }
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
    
    override func viewDidAppear(animated: Bool) {
        if let authorizer = service.authorizer,
            canAuth = authorizer.canAuthorize where canAuth {
            fetchEvents()
            calendarLabel.hidden = false
        }
        else{
            calendarLabel.hidden = true
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
    

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath) as! DashboardTableViewCell
//        cell.tableViewLabel?.text = titlesString[indexPath.row]
        cell.calendarTableViewLabel?.text = "Google Calendar"
       return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
}