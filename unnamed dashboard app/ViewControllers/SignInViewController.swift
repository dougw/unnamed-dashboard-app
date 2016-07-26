//
//  SignInViewController.swift
//  unnamed dashboard
//
//  Created by Dylan Steck on 7/15/16.
//  Copyright © 2016 Dylan Steck. All rights reserved.
//


import Foundation
import CopperKit
import UIKit
//import RealmSwift
class SignInViewController: UIViewController {
    
    // Signed Out view IB Variables
    @IBOutlet weak var signedOutView: UIView!
    @IBOutlet weak var signinButton: UIButton!
    @IBOutlet weak var optionsButton: UIButton!
    @IBOutlet weak var versionLabel: UILabel!
    // Signed In view IB Variables
    @IBOutlet weak var signedInView: UIView!
    @IBOutlet weak var signoutButton: UIButton!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    //    @IBOutlet weak var continueButton: UIButton!
    static let DefaultScopes: [C29Scope] = [.Name, .Email, .Phone]
    // Reference to our CopperKit singleton
    var copper: C29Application?
    var currentControllerDylan = DashboardViewController()

    var desiredScopes: [C29Scope]? = SignInViewController.DefaultScopes
    override func viewDidLoad(){
        copper?.closeSession()
//        resetView()
        super.viewDidLoad()
        //        topLogo.alpha = 0.0
        //        UIView.animateWithDuration(3.0) {
        //          self.topLogo.alpha = 1.0
    }
    // get a reference to our CopperKit application instance
    // get a reference to our CopperKit application instance
    @IBAction func signinButtonPressed(sender: AnyObject){
        copper = C29Application.sharedInstance
        // Required: configure it with our app's token
        copper!.configureForApplication("578921F60246F042B3084ADD9B91E1FB4B916CEB")
        // Optionally, decide what information we want from the user, defaults to C29Scope.DefaultScopes = [C29Scope.Name, C29Scope.Picture, C29Scope.Phone]
        copper!.scopes = desiredScopes
        // OK, let's make our call
        copper!.login(withViewController: self, completion: { (result: C29UserInfoResult) in
            switch result {
             case .Success://(userInfo):
               self.performSegueWithIdentifier("segueIdentifier", sender: self)
           
//                self.setupViewWithUserInfo(userInfo)
              print("lol")
                
            case .UserCancelled:
                print("The user cancelled.")
            case let .Failure(error):
                print("Bummer: \(error)")
            }
        })
    }
    
   
    
}
//    func setupViewWithUserInfo(userInfo: C29UserInfo) {
//        self.avatarImageView.image = userInfo.picture // userInfo.pictureURL is available, too
//        self.nameLabel.text = ("Hello, \(userInfo.fullName)!\n")
//        self.phoneLabel.text = userInfo.phoneNumber
//        // flip our signout state
//        self.signedInView.hidden = false
//        self.signedOutView.hidden = true
//    }
    
//    func resetView() {
//        // set our version string
//        // reset our signed in state
//        self.avatarImageView.image = nil
//        self.nameLabel.text = ""
//        self.phoneLabel.text = ""
//        // flip our state to the signed out state
//        self.signedInView.hidden = true
//        self.signedOutView.hidden = false
//    }
//   
    
//    @IBAction func signoutButtonPressed(sender: AnyObject) {
//        copper?.closeSession()
////        resetView()
//    }


