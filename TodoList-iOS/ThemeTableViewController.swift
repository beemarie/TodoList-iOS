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

class ThemeTableViewController: UITableViewController {

    // Setup TableView and TableViewCells

    override func viewWillAppear(_ animated: Bool) {
        ThemeManager.replaceGradient(inView: tableView)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Theme.allValues.count
    }

    override func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView
            .dequeueReusableCell(withIdentifier: "ThemeCell", for: indexPath) as UITableViewCell

        cell.textLabel?.text = Theme.allValues[indexPath.row].rawValue
        cell.textLabel?.textColor = ThemeManager.currentTheme().fontColor

        if Theme.allValues[indexPath.row] == ThemeManager.currentTheme() {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.none
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: NSIndexPath) {

        if ThemeManager.currentTheme() != Theme.allValues[indexPath.row] {
            ThemeManager.switchTheme()
            ThemeManager.replaceGradient(inView: view)
            tableView.reloadData()
        }

        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}
