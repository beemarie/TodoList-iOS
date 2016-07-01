//
//  LoginDataManager.swift
//  TodoList-iOS
//
//  Created by Aaron Liberatore on 6/29/16.
//  Copyright © 2016 Swift@IBM Engineering. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginDataManager: NSObject {

    static let sharedInstance = LoginDataManager()

    func login(viewController: UIViewController) {
        let login = FBSDKLoginManager()
        login.logIn(withReadPermissions: ["email"], from: viewController) {
            (result: FBSDKLoginManagerLoginResult!, error: NSError!) in
            
            if error != nil {
                print(error.localizedDescription)

            } else if result.isCancelled {
                return

            } else {
                if result.grantedPermissions.contains("id") {
                    self.fetchUserInfo()
                }
            }
        }
    }

    func logout() {
        for key in Array(NSUserDefaults.standard().dictionaryRepresentation().keys) {
            NSUserDefaults.standard().removeObject(forKey: key)
        }

        let login = FBSDKLoginManager()
        FBSDKAccessToken.setCurrent(nil)
        login.logOut()
    }

    func fetchUserInfo() {
        FBSDKGraphRequest.init(graphPath: "me",
                               parameters: ["fields":"id, first_name, last_name, email"])
            .start { (connection, result, error) -> Void in

            // Check error condition or save user Data
            if (error) != nil {
                print(error.localizedDescription)

            } else {
                User.facebookUserID = (result.objectFor("id") as? String)!
                User.fullName = (result.objectFor("first_name") as? String)! + " " +
                                (result.objectFor("last_name") as? String)!
                User.email = (result.objectFor("email") as? String)!
            }
        }
    }
}
