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

class HeaderCell: UITableViewCell, UITextFieldDelegate, editFieldDelegate {
    @IBOutlet var editField: UITextField!

    var indexPath: NSIndexPath?

    override func awakeFromNib() {
        super.awakeFromNib()
        editField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func onAddItem(sender: UIButton) {
        if let title = editField.text {
            TodoItemDataManager.sharedInstance.add(withTitle: title)
            editField.text = nil
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let title = textField.text {
            TodoItemDataManager.sharedInstance.add(withTitle: title)
            editField.text = nil
            return true
        }
        return false
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = nil
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.placeholder = "What Needs To Be Done?"
    }

    func isEditing(todo: TodoItem) {

    }
}
