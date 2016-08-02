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

class TableViewPageController: UIViewController{
    var myArticles = [JSON]() ?? []
//    var titlesString = [String]()
    var myString = [JSON]() ?? []
    var myVar = [JSON]() ?? []
    @IBOutlet weak var myCoolLabel: UILabel!
    var services = ["Calendar", "Google News", "Weather", "Social Feed" ]
@IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var myTextView: UITextView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var calendarNameView: UIView!
    @IBOutlet weak var calendarNameLabel: UILabel!
    @IBOutlet weak var titlesString: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let colors:[UIColor] = [
           UIColor(red:0.00, green:0.82, blue:0.62, alpha:1.0), UIColor(red:0.08, green:0.13, blue:0.39, alpha:1.0)
        ]
        let background = GradientColor(.TopToBottom, frame: view.frame, colors: colors)
//           view.backgroundColor = background
        view.backgroundColor = FlatSkyBlue()
         self.calendarNameLabel.font = UIFont(name: "Montserrat-Regular", size: 15)!
//        self.calendarNameView.layer.borderWidth = 2.5
//        self.calendarNameView.layer.borderColor = UIColor(red:0.07, green:0.00, blue:0.00, alpha:1.0).CGColor
//        secondView.backgroundColor = background
        EventStore.requestAccess() { (granted, error) in
            if granted {
                print("got permission")
            }
        }
    
    
        let events = EventStore.getEvents(Month(year: 2016, month: 6))
        
        if events != nil {
            for e in events {
                myCoolLabel.text = ("Today you have \(e.title)")
                print("startDate: \(e.startDate)")
                print("endDate: \(e.endDate)")
            
        }
        
    }
        else {
            print("You have 0 events on your calendar today.")
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
                for article in self.myVar {
                    let title = article["title"].stringValue
                    self.titlesString.text = title
                    
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
