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

import Foundation
import UIKit

protocol editFieldDelegate {
    func isEditing(todo: TodoItem)
}
class TodoTableViewController: UITableViewController, TodoItemsDelegate {

    var showCompleted = true

    var layer: CAGradientLayer? = nil

    @IBAction func showCompleted(sender: UIButton) {
        showCompleted = !showCompleted
        updateTable(todoItems: todos())
    }

    override func viewWillAppear(_ animated: Bool) {
        layer = ThemeManager.gradientLayer(layer: layer, view: tableView)
        ThemeManager.applyTheme(theme: ThemeManager.currentTheme())
        updateTable(todoItems: todos())
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        TodoItemDataManager.sharedInstance.delegate = self
        /*self.tableView.contentInset =
           UIEdgeInsetsMake(0, 0, self.tableView.frame.size.height - 88, 0)*/
    }

    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: NSIndexPath) -> CGFloat {
        if showCompleted == false &&
           todos()[indexPath.section][indexPath.row].completed {
                return 0
            }
        return 50
    }

    // Setup Table Section Headers

    override func tableView(_ tableView: UITableView,
                            heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    override func tableView(_ tableView: UITableView,
                            viewForHeaderInSection section: Int) -> UIView? {

        if section == 0 {
            let headerCell = (tableView
                .dequeueReusableCell(withIdentifier: "HeaderCell") as? HeaderCell)!

            headerCell.backgroundColor = UIColor.clear()
            headerCell.editField = UITextField()

            let containerView = UIView(frame:headerCell.frame)
            headerCell.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            containerView.addSubview(headerCell)

            return containerView

        } else {
            let optionCell = (tableView
                .dequeueReusableCell(withIdentifier: "OptionCell") as? OptionCell)!

            optionCell.backgroundColor = UIColor.clear()
            optionCell.showButton.layer.cornerRadius = 10
            optionCell.label.text = showCompleted ? "Hide Completed" : "Show Completed"

            let containerView = UIView(frame:optionCell.frame)
            optionCell.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            containerView.addSubview(optionCell)

            return containerView
        }
    }

    // Setup Editing Styles

    override func tableView(_ tableView: UITableView,
                            shouldIndentWhileEditingRowAt indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func tableView(_ tableView: UITableView,
                            editingStyleForRowAt indexPath: NSIndexPath)
                                -> UITableViewCellEditingStyle {

        return tableView.isEditing ? UITableViewCellEditingStyle.none:
                                     UITableViewCellEditingStyle.delete
    }

    // Handle Pull Out Edit Bar

    override func tableView(_ tableView: UITableView,
                            editActionsForRowAt indexPath: NSIndexPath) -> [UITableViewRowAction]? {

        let onDelete = { (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            TodoItemDataManager.sharedInstance.delete(itemAt: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }

        let onEdit = { (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            // TODO: MAKE EDIT WORK
            tableView.isEditing = false
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
        let editAction = UITableViewRowAction(style: .normal, title: "Edit", handler: onEdit)
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: onDelete)

        editAction.backgroundColor = ThemeManager.currentTheme().accessoryColor

        return [deleteAction, editAction]
    }

    // Setup TableView and TableViewCells

    override func numberOfSections(in tableView: UITableView) -> Int {
        return todos().count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos()[section].count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView
            .dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath) as UITableViewCell

        var textAttributes = [
                             NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 17.0)!,
                             NSForegroundColorAttributeName: ThemeManager.currentTheme().fontColor
                             ]
        cell.textLabel?.attributedText = NSAttributedString(
                            string: todos()[indexPath.section][indexPath.row].title,
                            attributes: textAttributes)

        cell.shouldIndentWhileEditing = false
        cell.backgroundColor = UIColor.clear()

        if self.isEditing {
            cell.imageView?.image = UIImage(named: "trash")

        } else {
            if todos()[indexPath.section][indexPath.row].completed {
                cell.imageView?.image = UIImage(named: "blue_checkmark")

                textAttributes[NSStrikethroughStyleAttributeName] = NSNumber(value:
                                        NSUnderlineStyle.styleSingle.rawValue)

                cell.textLabel?.attributedText =
                    NSAttributedString(string: todos()[indexPath.section][indexPath.row].title,
                                   attributes: textAttributes)
            } else {
                cell.imageView?.image = UIImage(named: "clear_checkmark")
            }
        }

        return cell
    }


    // Setup Movable Rows

    @IBAction func onEditClicked(sender: UIBarButtonItem) {
        self.isEditing = !self.isEditing
        updateTable(todoItems: todos())
    }

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView,
                            moveRowAt sourceIndexPath: NSIndexPath,
                            to destinationIndexPath: NSIndexPath) {

        TodoItemDataManager.sharedInstance.move(itemAt: sourceIndexPath, to: destinationIndexPath)
        updateTable(todoItems: todos())

    }

    override func tableView(_ tableView: UITableView,
                            targetIndexPathForMoveFromRowAt sourceIndexPath: NSIndexPath,
                            toProposedIndexPath
                                proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
        if sourceIndexPath.section != proposedDestinationIndexPath.section {
            var row = 0
            if sourceIndexPath.section < proposedDestinationIndexPath.section {
                row = tableView.numberOfRows(inSection: sourceIndexPath.section) - 1
            }
            return NSIndexPath(forRow: row, inSection: sourceIndexPath.section)
        }
        return proposedDestinationIndexPath
    }

    // Allows Trash and Completion Marking

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: NSIndexPath) {

        if self.isEditing {
            TodoItemDataManager.sharedInstance.delete(itemAt: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)

        } else {
            TodoItemDataManager.sharedInstance.updateCompletion(indexPath: indexPath)
            updateTable(todoItems: TodoItemDataManager.sharedInstance.allTodos)

        }

    }

    func updateTable(todoItems: [[TodoItem]]) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
        })

    }

    func todos() -> [[TodoItem]] {
        return TodoItemDataManager.sharedInstance.allTodos
    }

    func onItemsAddedToList() {
        updateTable(todoItems: todos())
    }
    // Handle Scrolling Functions

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for cell in tableView.visibleCells {
            let hiddenFrameHeight = scrollView.contentOffset.y +
                (self.navigationController?.navigationBar.frame.size.height)! - cell.frame.origin.y

            hiddenFrameHeight >= -50 ? cell.maskCellFromTop(margin: hiddenFrameHeight) :
                                      (cell.layer.mask = nil)
        }
    }
}

extension UITableViewCell {

    func maskCellFromTop(margin: CGFloat) {
        //self.layer.mask = self.marg
        self.layer.mask = visibilityMaskWithLocation(location: margin/self.frame.size.height)
        self.layer.masksToBounds = true
    }

    func visibilityMaskWithLocation(location: CGFloat) -> CAGradientLayer {
        let mask = CAGradientLayer()
        mask.frame = CGRect(x: self.bounds.origin.x,
                            y: location+self.bounds.origin.y,
                            width: self.bounds.size.width,
                            height: self.bounds.size.height-location)
        mask.colors = [UIColor.white().withAlphaComponent(0),
                       UIColor.white().withAlphaComponent(1)]
        mask.locations = [location, location]
        return mask
    }
}
