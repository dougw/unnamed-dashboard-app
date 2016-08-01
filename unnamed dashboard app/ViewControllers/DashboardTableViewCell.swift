//
//  DashboardTableViewCell.swift
//  WebDeck
//
//  Created by Dylan Steck on 8/1/16.
//  Copyright © 2016 WebDeck. All rights reserved.
//


import UIKit

class DashboardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var calendarLabel: UILabel!
    @IBOutlet weak var connectCalendarButton: UIButton!
    @IBOutlet weak var output: UITextView!
    @IBOutlet weak var calendarTableViewLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

