//
//  UtilitiesViewController.swift
//  WebDeck
//
//  Created by Dylan Steck on 7/25/16.
//  Copyright © 2016 Dylan Steck. All rights reserved.
//

import Foundation
import UIKit
import ChameleonFramework
class UtilitiesViewController: UIViewController {
    @IBOutlet weak var topButton: UIButton!
    @IBOutlet weak var lifestyleButton: UIButton!
    @IBOutlet weak var socialButton: UIButton!
    @IBOutlet weak var utilitiesButton: UIButton!
    override func viewDidLoad(){
        super.viewDidLoad()
        self.topButton.titleLabel!.font = UIFont(name: "Montserrat-Regular", size: 15)!
        self.lifestyleButton.titleLabel!.font = UIFont(name: "Montserrat-Regular", size: 15)!
        self.socialButton.titleLabel!.font = UIFont(name: "Montserrat-Regular", size: 15)!
        self.utilitiesButton.titleLabel!.font = UIFont(name: "Montserrat-Regular", size: 15)!
        
        let colors:[UIColor] = [
            UIColor.flatWatermelonColor(),
            UIColor.flatSkyBlueColor()
        ]
        
        var background = GradientColor(.TopToBottom, frame: view.frame, colors: colors)
        view.backgroundColor = background

    }
}
