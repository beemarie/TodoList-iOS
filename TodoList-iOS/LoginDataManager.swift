/**
 * Copyright IBM Corporation 2016
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

import UIKit
import FBSDKLoginKit

class LoginDataManager: NSObject {

    static let sharedInstance = LoginDataManager()

    func login(viewController: UIViewController) {
        let login = FBSDKLoginManager()
        login.logIn(withReadPermissions: ["email"], from: viewController) {
            (result: FBSDKLoginManagerLoginResult?, error: NSError?) in

            if let error = error {
                print(error.localizedDescription)
            }
            if let result = result {
                if result.isCancelled {
                    return
                } else {
                    if result.grantedPermissions.contains("id") {
                        self.fetchUserInfo()
                    }
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
            if let error = error {
                print(error.localizedDescription)

            } else {
                User.facebookUserID = (result?.objectFor("id") as? String)!
                User.fullName = (result?.objectFor("first_name") as? String)! + " " +
                                (result?.objectFor("last_name") as? String)!
                User.email = (result?.objectFor("email") as? String)!
            }
        }
    }
}
