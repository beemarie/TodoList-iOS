//
//  TodoItemDataManager.swift
//  TodoList-iOS
//
//  Created by Aaron Liberatore on 6/15/16.
//  Copyright © 2016 Swift@IBM Engineering. All rights reserved.
//

import UIKit
import Foundation

class TodoItemDataManager: NSObject {
    
    let config = BluemixConfiguration()
    
    let router = Router()
    
    static let sharedInstance = TodoItemDataManager()
    
    var allTodos = [TodoItem]()
    
    override init() {
        super.init()
        getMyTodos(uid: User.facebookUserId)
    }
    
}

// MARK: Methods for storing, deleting, updating, and retrieving
extension TodoItemDataManager {
        
    
    // Store item in todolist
    func store(title: String){
        
        /*let facebookCredentials Version = "{\"title\":\"\(title)\",\"completed\":\"\(false)\",\"order\":\"\(TodoItemDataManager.sharedInstance.allTodos.count + 1)\"}"*/
        let json = "{\"uid\":\"\(User.facebookUserId)\",\"title\":\"\(title)\",\"completed\":\"\(false)\",\"order\":\"\(TodoItemDataManager.sharedInstance.allTodos.count + 1)\"}"
        
        router.HTTPPost(url: getBaseRequestURL(), jsonObj: json) {
            data, error in
            if error != nil { print(error?.localizedDescription) }
            else {
                do {
                    let json = try NSJSONSerialization.jsonObject(with: data, options: .mutableContainers)
                    self.allTodos.append(self.parseItem(item: json)!)

                } catch { print("Error Storing Data") }
            }
        }

    }
    
    func delete(at: NSIndexPath) {
        
        let id = allTodos[at.row].id
        TodoItemDataManager.sharedInstance.allTodos.remove(at: at.row)
        
        router.HTTPDelete(url: "\(getBaseRequestURL())/todos/\(id)") {
            data, error in
            if error != nil { print(error?.localizedDescription) }
        }
    }
    
    func update(item: TodoItem) {
        router.HTTPPatch(url: "\(getBaseRequestURL())/todos/\(item.id)", jsonObj: item.jsonRepresentation) {
            data, error in
            if error != nil { print(error?.localizedDescription) }
        }
        
    }
    
    func get(id: String) -> TodoItem? {
        
        var item: TodoItem? = nil
        
        router.HTTPGet(url: "\(getBaseRequestURL())/todos/private/\(id)") {
            data, error in
            if error != nil { print(error?.localizedDescription) }
            else {
                do {
                    let json = try NSJSONSerialization.jsonObject(with: data, options: .mutableContainers)
                    item = self.parseItem(item: json)
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
        }
        
        return item
        
    }
    
    // Loads todolist from url
    
    func getAllTodos() {
        
        router.HTTPGet(url: getBaseRequestURL()) {
            data, error in
            if error != nil { print(error?.localizedDescription) }
            else {
                do {
                    let json = try NSJSONSerialization.jsonObject(with: data, options: .mutableContainers)
                    self.parseTodoList(json: json)
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func getMyTodos(uid: String) {
        
        router.HTTPGet(url: "\(getBaseRequestURL())/todos/private/\(uid)") {
            data, error in
            if error != nil { print(error?.localizedDescription) }
            else {
                do {
                    let json = try NSJSONSerialization.jsonObject(with: data, options: .mutableContainers)
                    self.parseTodoList(json: json)
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

// MARK: Methods for Parsing Functions
extension TodoItemDataManager {
    
    private func parseTodoList(json: AnyObject){
        
        allTodos.removeAll()
        
        if let json = json as? [AnyObject] {
            
            for item in json {
                
                guard let todo = parseItem(item: item) else {
                    continue
                }
                
                insertSorted(seq: &allTodos, newItem: todo)
                
            }
            
        }
    }
    
    private func parseItem(item: AnyObject) -> TodoItem? {
        if let item = item as? [String: AnyObject] {
            
            let id        = item["id"] as? String
            let title     = item["title"] as? String
            let completed = item["completed"] as? Bool
            let order     = item["order"] as? Int
            
            guard let uid = id,
                let titleValue = title,
                let completedValue = completed,
                let orderValue = order else {
                    
                    return nil
            }
            
            
            return TodoItem(id: uid, title: titleValue, completed: completedValue, order: orderValue)
        }
        
        return nil
    }
}

// MARK: - Utility functions
extension TodoItemDataManager {
    
    func getBaseRequestURL() -> String {
        
        if config.isLocal {
            return config.localBaseRequestURL
        } else {
            return config.remoteBaseRequestURL
        }
    }
    
    func insertSorted<T: Comparable>( seq: inout [T], newItem item: T) {
        let index = seq.reduce(0) { $1 < item ? $0 + 1 : $0 }
        seq.insert(item, at: index)
    }
    
    func move(at: NSIndexPath, to: NSIndexPath) {
        
        var itemToMove = allTodos[at.row]
        
        itemToMove.order = allTodos[to.row].order
        
        allTodos.remove(at: at.row)
        allTodos.insert(itemToMove, at: to.row)
        
        // Update order on server
        TodoItemDataManager.sharedInstance.update(item: itemToMove)
    }
}
