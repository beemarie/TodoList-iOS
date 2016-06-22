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
import FBSDKCoreKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    /// Loading indicator when connecting to Facebook
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    /// Button to allow user to sign in with Facebook
    @IBOutlet weak var facebookButton: FBSDKLoginButton!
    
    /// Label to show an error if authentication is unsuccessful
    @IBOutlet weak var welcomeLabel: UILabel!

    override func viewWillAppear(_ animated: Bool) {
        if (FBSDKAccessToken.current() != nil) {
            
            dispatch_async(dispatch_get_main_queue()) {
                [unowned self] in
                self.performSegue(withIdentifier: "todolist", sender: self)
            }
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        facebookButton.layer.cornerRadius = 10
        
        configureFacebook()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureFacebook()
    {
        facebookButton.readPermissions = ["public_profile", "email"];
        facebookButton.delegate = self
    }

    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: NSError!) {

        FBSDKGraphRequest.init(graphPath: "me",
                               parameters: ["fields":"id, first_name, last_name, email"]).start { (connection, result, error) -> Void in
            
            // Check error condition or save user Data
            if ((error) != nil) {
                print(error.localizedDescription)
            } else {
                
                User.facebookUserId = (result.objectFor("id") as? String)!
                User.fullName = (result.objectFor("first_name") as? String)! + " " + (result.objectFor("last_name") as? String)!
                User.email = (result.objectFor("email") as? String)!

                self.welcomeLabel.text = "Welcome, \(User.fullName)"
                
            }
                                
        }
        
        
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!){
        for key in Array(NSUserDefaults.standard().dictionaryRepresentation().keys) {
            NSUserDefaults.standard().removeObject(forKey: key)
        }
    
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
