//
//  DashboardViewController.swift
//  unnamed dashboard
//
//  Created by Dylan Steck on 7/15/16.
//  Copyright © 2016 Dylan Steck. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import ChameleonFramework
import CopperKit
import TwitterKit

class DashboardViewController: UIViewController{
    // IBOutlets for the output(where the Google Cal events go), the connectCalendarButton(where you connect your Google account for the API), the Calendar label(just a label for the calendar section), and a newsTextView(text view for the NewsAPI).
    var myArticles = [JSON]() ?? []
    var titlesString = [String]()
    var myString = [JSON]() ?? []
    @IBOutlet weak var topButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lifestyleButton: UIButton!
    @IBOutlet weak var socialButton: UIButton!
    @IBOutlet weak var utilitiesButton: UIButton!
    //    @IBOutlet weak var newsTextView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    
    
    var name: String?
    
    
    // When the view loads, create necessary subviews
    // and initialize the Google Calendar API service
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Twitter start
        // Add a button to the center of the view to show the timeline
        let button = UIButton(type: .System)
        button.setTitle("Show Timeline", forState: .Normal)
        button.sizeToFit()
        button.center = view.center
        button.addTarget(self, action: #selector(showTimeline), forControlEvents: [.TouchUpInside])
        view.addSubview(button)
        //Twitter end
        //All of this output stuff just sets size and features to the output for the Google Calendar API.
        //        self.output.frame = view.bounds
        
        // The let colors and view.backgroundColor are all for a gradient, which requires ChameleonFramework.
        let colors:[UIColor] = [
            UIColor(red:0.96, green:0.78, blue:0.81, alpha:1.0),
            UIColor(red:0.52, green:0.67, blue:0.79, alpha:1.0)
        ]
        let colorsForTextView: [UIColor] = [
            UIColor(red:0.96, green:0.78, blue:0.81, alpha:1.0)
        ]
        let background = GradientColor(.TopToBottom, frame: view.frame, colors: colors)
        var backgroundOther = GradientColor(.TopToBottom, frame: view.frame, colors: colorsForTextView)
        view.backgroundColor = background
        //        output.backgroundColor = backgroundOther
        //        Makes sure that the newsTextView isn't editable.
        //      newsTextView.editable = false
        
        
        
        
        
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
    
    //This just makes sure that the label that says calendar is hidden if the user isn't logged in to Google.
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if name == "nil"{
            nameLabel.text = "Hello, \(name!)!"
        }
        else{
            nameLabel.hidden = true
        }
    }
    //Twitter
    func showTimeline() {
        // Create an API client and data source to fetch Tweets for the timeline
        let client = TWTRAPIClient()
        let dataSource = TWTRUserTimelineDataSource(screenName: "dylsteck", APIClient: client)
        // Create the timeline view controller
        let timelineViewControlller = TWTRTimelineViewController(dataSource: dataSource)
        // Create done button to dismiss the view controller
        let button = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(dismissTimeline))
        timelineViewControlller.navigationItem.leftBarButtonItem = button
        // Create a navigation controller to hold the
        let navigationController = UINavigationController(rootViewController: timelineViewControlller)
        showDetailViewController(navigationController, sender: self)
    }
    func dismissTimeline() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    //End twitter
    
}

extension DashboardViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myArticles.count
//        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! NewsTableViewCell
        cell.tableViewLabel?.text = titlesString[0]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
}