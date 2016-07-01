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

class LoginViewController: UIViewController {

    @IBAction func loginButton(sender: UIButton) {
        LoginDataManager.sharedInstance.login(viewController: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        if FBSDKAccessToken.current() != nil {
            dispatch_async(dispatch_get_main_queue()) {
                [unowned self] in
                self.performSegue(withIdentifier: "todolist", sender: self)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set Background Theme
        let gradientLayer = CAGradientLayer()

        gradientLayer.frame = self.view.bounds
        gradientLayer.locations = [0.0, 1]
        gradientLayer.colors = [ Theme.Dark.mainColor.cgColor, Theme.Dark.secondaryColor.cgColor]

        view.backgroundColor = UIColor.clear()
        let backgroundLayer = gradientLayer
        backgroundLayer.frame = view.frame
        view.layer.insertSublayer(backgroundLayer, at: 0)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
