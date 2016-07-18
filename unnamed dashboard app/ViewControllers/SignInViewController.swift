//
//  SignInViewController.swift
//  unnamed dashboard
//
//  Created by Dylan Steck on 7/15/16.
//  Copyright © 2016 Dylan Steck. All rights reserved.
//

import Foundation
//import CopperKit
import UIKit
//import RealmSwift
class SignInViewController: UIViewController {
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
//    override func viewDidLoad(){
//        super.viewDidLoad()
////        topLogo.alpha = 0.0
////        UIView.animateWithDuration(3.0) {
////            self.topLogo.alpha = 1.0
////        }
//    // get a reference to our CopperKit application instance
//    // get a reference to our CopperKit application instance
//    let copper = C29Application.sharedInstance
//    // Required: configure it with our app's token
//copper.configureForApplication("578921F60246F042B3084ADD9B91E1FB4B916CEB")
//    // Optionally, decide what information we want from the user, defaults to C29Scope.DefaultScopes = [C29Scope.Name, C29Scope.Picture, C29Scope.Phone]
//    copper.scopes = [.Name, .Email, .Phone]
//    // OK, let's make our call
//    copper.login(withViewController: self, completion: { (result: C29UserInfoResult) in
//    switch result {
//    case let .Success(userInfo):
//    // if we get here then the user completed successfully
//    let userId = userInfo.userId
//    let name = userInfo.fullName
//    let picture = userInfo.picture
//    let email = userInfo.emailAddress
//    let phone = userInfo.phoneNumber
//    // continue to inspect userInfo and take it away from here...
//    case .UserCancelled:
//    print("The user cancelled.")
//    case let .Failure(error):
//    print("Bummer: \(error)")
//    }
//    })
//}
}
