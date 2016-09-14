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
            DispatchQueue.main.async {
                [unowned self] in
                self.performSegue(withIdentifier: "todolist", sender: self)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        ThemeManager.applyTheme(theme: ThemeManager.currentTheme())
        ThemeManager.replaceGradient(inView: self.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func willAnimateRotation(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        view.layer.sublayers?.first?.frame = self.view.bounds
    }
}
