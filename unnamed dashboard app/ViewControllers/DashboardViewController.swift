////
////  DashboardViewController.swift
////  unnamed dashboard
////
////  Created by Dylan Steck on 7/15/16.
////  Copyright © 2016 Dylan Steck. All rights reserved.
////
//
//import Foundation
//import UIKit
//import Alamofire
//import SwiftyJSON
//import ChameleonFramework
//import CopperKit
//import TwitterKit
//
//class DashboardViewController: UIViewController{
//    @IBOutlet weak var nameLabel: UILabel!
//    
//    var name: String
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        //Twitter start
//        // Add a button to the center of the view to show the timeline
//        let button = UIButton(type: .System)
//        button.setTitle("Show Timeline", forState: .Normal)
//        button.sizeToFit()
//        button.center = view.center
//        button.addTarget(self, action: #selector(showTimeline), forControlEvents: [.TouchUpInside])
//        view.addSubview(button)
//        //Twitter end
//        //All of this output stuff just sets size and features to the output for the Google Calendar API.
//        //        self.output.frame = view.bounds
//        
//        // The let colors and view.backgroundColor are all for a gradient, which requires ChameleonFramework.
//        let colors:[UIColor] = [
//            UIColor(red:0.96, green:0.78, blue:0.81, alpha:1.0),
//            UIColor(red:0.52, green:0.67, blue:0.79, alpha:1.0)
//        ]
//        let colorsForTextView: [UIColor] = [
//            UIColor(red:0.96, green:0.78, blue:0.81, alpha:1.0)
//        ]
//        let background = GradientColor(.TopToBottom, frame: view.frame, colors: colors)
//        var backgroundOther = GradientColor(.TopToBottom, frame: view.frame, colors: colorsForTextView)
//        view.backgroundColor = background
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//        if name == "nil"{
//            nameLabel.hidden = true
//        }
//        else{
//             nameLabel.text = "Hello, \(name!)!"
//        }
//    }
//    //Twitter
//    func showTimeline() {
//        // Create an API client and data source to fetch Tweets for the timeline
//        let client = TWTRAPIClient()
//        let dataSource = TWTRUserTimelineDataSource(screenName: "dylsteck", APIClient: client)
//        // Create the timeline view controller
//        let timelineViewControlller = TWTRTimelineViewController(dataSource: dataSource)
//        // Create done button to dismiss the view controller
//        let button = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(dismissTimeline))
//        timelineViewControlller.navigationItem.leftBarButtonItem = button
//        // Create a navigation controller to hold the
//        let navigationController = UINavigationController(rootViewController: timelineViewControlller)
//        showDetailViewController(navigationController, sender: self)
//    }
//    func dismissTimeline() {
//        dismissViewControllerAnimated(true, completion: nil)
//    }
//    //End twitter
//    
//}
