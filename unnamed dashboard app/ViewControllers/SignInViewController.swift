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
import ChameleonFramework

class SignInViewController: UIViewController {
    //IBOutlets: the descLabel is the one that says: Life should be open. Let's start now. The signInButton is the Sign In button.
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var signinButton: UIButton!
    //    The scopes we want from Copper
    static let DefaultScopes: [C29Scope] = [.Name, .Email, .Phone]
    // Reference to our CopperKit singleton
    var copper: C29Application?
    //Calling on fullName as a string to make sure we can pass the name to the DashboardViewController.
    var fullName: String?
    //Setting which scopes we want, using the DefaultScopes static let up above.
    var desiredScopes: [C29Scope]? = SignInViewController.DefaultScopes
    
    override func viewDidLoad(){
//        copper?.closeSession()
        //        resetView()
        super.viewDidLoad()
//        let colors:[UIColor] = [
////            UIColor(red:0.96, green:0.78, blue:0.81, alpha:1.0),
////           UIColor(red:0.52, green:0.67, blue:0.79, alpha:1.0)
//            flatPowderBlue
//        ]
//        let background = GradientColor(.TopToBottom, frame: view.frame, colors: colors)
//        view.backgroundColor = background
         view.backgroundColor = FlatPowderBlue()
//        var label = UILabel(frame: CGRectMake(20, 70, 300, 300))
//        label.text = "Life should be open. Let's start now."
        descLabel.font = UIFont(name: "Montserrat-Light", size: 15)
        signinButton.titleLabel!.font =  UIFont(name: "Montserrat-Regular", size: 30)
//        self.view.addSubview(label)
        
        //        topLogo.alpha = 0.0
        //        UIView.animateWithDuration(3.0) {
        //          self.topLogo.alpha = 1.0
    }
    // get a reference to our CopperKit application instance
    // get a reference to our CopperKit application instance
    @IBAction func signinButtonPressed(sender: AnyObject){
        copper = C29Application.sharedInstance
        // Required: configure it with our app's token
        copper!.configureForApplication("579A489835846340FC4C4B41A8FD48B5893B470C")
        // Optionally, decide what information we want from the user, defaults to C29Scope.DefaultScopes = [C29Scope.Name, C29Scope.Picture, C29Scope.Phone]
        copper!.scopes = desiredScopes
        // OK, let's make our call
        copper!.login(withViewController: self, completion: { (result: C29UserInfoResult) in
            switch result {
            case let .Success(userInfo):
                self.fullName =  userInfo.fullName
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueIdentifier" {
            let destinationVC = segue.destinationViewController as! DashboardViewController
            destinationVC.name = fullName
            
        }
        //
        
    }
    
    
    
}

//  func setupViewWithUserInfo(userInfo: C29UserInfo) {
//
//}

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