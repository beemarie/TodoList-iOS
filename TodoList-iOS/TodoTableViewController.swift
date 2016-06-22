//
//  TodoTableViewController.swift
//  TodoList-iOS
//
//  Created by Robert Dickerson on 5/12/16.
//  Copyright © 2016 Swift@IBM Engineering. All rights reserved.
//

import Foundation
import UIKit
//import Credentials


class TodoTableViewController: UITableViewController {
    
    @IBOutlet weak var mySegmentedControl: UISegmentedControl!
    
    override func viewDidAppear(_ animated: Bool) {
        TodoItemDataManager.sharedInstance.getMyTodos(uid: User.facebookUserId)
        updateTable(todoItems: todos())
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func segmentedControlActionChanged(sender: AnyObject) {
        tableView.reloadData()
    }
    
    // Setup TableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos().count
    }
    
    // Handle Checkmarks
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        
        cell.textLabel?.text = todos()[indexPath.row].title
        
        
        if (todos()[indexPath.row].completed) {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        
        return cell
    }
    
    
    // Allows Movable Rows
    
    @IBAction func onEditClicked(sender: UIBarButtonItem) {
        self.isEditing = !self.isEditing
        
    }
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: NSIndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: NSIndexPath, to destinationIndexPath: NSIndexPath) {

        TodoItemDataManager.sharedInstance.move(at: sourceIndexPath, to: destinationIndexPath)
        
    }
    
    // Hides Completed Rows When looking at todos
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: NSIndexPath) -> CGFloat {
        if mySegmentedControl.selectedSegmentIndex == 0 {
            if todos()[indexPath.row].completed {
                return 0
            }
            return 50
        }
        return 50

    }
    
    // Allows Completion Marking
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: NSIndexPath) {
        
        TodoItemDataManager.sharedInstance.allTodos[indexPath.row].completed = !todos()[indexPath.row].completed
        
        self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        
        TodoItemDataManager.sharedInstance.update(item: todos()[indexPath.row])
        
    }
    
    // Allows Row Deletion
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: NSIndexPath) {
        
        if editingStyle == .delete {
            
            TodoItemDataManager.sharedInstance.delete(at: indexPath)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
        
    }
    
    func updateTable(todoItems: [TodoItem]) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
        })

    }
    // TODO: Figure out how to do switching.
    func todos() -> [TodoItem] {
        return TodoItemDataManager.sharedInstance.allTodos
    }
        
}