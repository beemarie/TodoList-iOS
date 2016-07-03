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

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBAction func logOutButton(sender: UIButton) {
        LoginDataManager.sharedInstance.logout()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let add = storyboard.instantiateInitialViewController()
        self.present(add!, animated: true, completion: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        ThemeManager.replaceGradient(inView: view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell",
                                                for: indexPath) as UITableViewCell

        cell.frame = CGRect(x: 0,
                            y: 0,
                            width: tableView.frame.size.width,
                            height: cell.frame.size.height)
        cell.textLabel?.text = "Color Theme"
        cell.textLabel?.textColor =  ThemeManager.currentTheme().fontColor
        cell.detailTextLabel?.text = ThemeManager.currentTheme().rawValue
        cell.detailTextLabel?.textColor =  ThemeManager.currentTheme().fontColor
        cell.accessoryType = .disclosureIndicator
        cell.imageView?.image = UIImage(named: "theme_logo")

        return cell
    }

    // Allows Completion Marking

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: NSIndexPath) {
        ThemeManager.switchTheme()
        ThemeManager.replaceGradient(inView: view)
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
}
