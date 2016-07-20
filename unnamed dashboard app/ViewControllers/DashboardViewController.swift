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

class DashboardViewController: UIViewController {
     @IBOutlet weak var output: UITextView!
    @IBOutlet weak var connectCalendarButton: UIButton!
    @IBOutlet weak var calendarLabel: UILabel!
    @IBOutlet weak var newsTextView: UITextView!
    
    var url = "https://newsapi.org/v1/articles?source=googlenews&sortBy=top&apiKey=76bf0e6c09c846fcae1484659167aa91"
    Alamofire.request(.GET, url).responseJSON { (req, res, json) -> Void in
    let swiftyJsonVar = JSON(json.value!)
    print(swiftyJsonVar)
    }
   

    
    private let kKeychainItemName = "Google Calendar API"
    private let kClientID = "973148780218-c56k2gq4a0riejfiok2eun5ffrerja82.apps.googleusercontent.com"
    
    // If modifying these scopes, delete your previously saved credentials by
    // resetting the iOS simulator or uninstall the app.
    private let scopes = [kGTLAuthScopeCalendarReadonly]
    
    private let service = GTLServiceCalendar()
    
    // When the view loads, create necessary subviews
    // and initialize the Google Calendar API service
    override func viewDidLoad() {
        super.viewDidLoad()
        
        output.frame = view.bounds
        output.editable = false
        output.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        output.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        
        view.addSubview(output);
        
        if let auth = GTMOAuth2ViewControllerTouch.authForGoogleFromKeychainForName(
            kKeychainItemName,
            clientID: kClientID,
            clientSecret: nil) {
            service.authorizer = auth
        }
        
    }
    
    // When the view appears, ensure that the Google Calendar API service is authorized
    // and perform API calls
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
}