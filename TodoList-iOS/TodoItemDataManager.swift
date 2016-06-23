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
import Foundation

class TodoItemDataManager: NSObject {

    let config = BluemixConfiguration()

    let router = Router()

    static let sharedInstance = TodoItemDataManager()

    var allTodos = [TodoItem]()

    override init() {
        super.init()
        get()
    }

}

// MARK: Methods for storing, deleting, updating, and retrieving
extension TodoItemDataManager {


    // Store item in todolist
    func add(withTitle: String) {

        let json = "{\"title\":\"\(withTitle)\",\"completed\":\"\(false)\",\"order\":\"\(TodoItemDataManager.sharedInstance.allTodos.count + 1)\"}"

        router.HTTPPost(url: getBaseRequestURL(), jsonObj: json) {
            data, error in
            if error != nil { print(error?.localizedDescription) } else {
                do {
                    let json = try NSJSONSerialization.jsonObject(with: data,
                                                                  options: .mutableContainers)
                    self.allTodos.append(self.parseItem(item: json)!)

                } catch { print("Error Storing Data") }
            }
        }

    }

    func delete(itemAt: NSIndexPath) {

        let id = allTodos[itemAt.row].id
        TodoItemDataManager.sharedInstance.allTodos.remove(at: itemAt.row)

        router.HTTPDelete(url: "\(getBaseRequestURL())/todos/\(id)") {
            data, error in
            if error != nil { print(error?.localizedDescription) }
        }
    }

    func update(item: TodoItem) {
        router.HTTPPatch(url: "\(getBaseRequestURL())/todos/\(item.id)",
                         jsonObj: item.jsonRepresentation) {
            data, error in

            if error != nil { print(error?.localizedDescription) }
        }

    }

    func get(withId: String) -> TodoItem? {

        var item: TodoItem? = nil

        router.HTTPGet(url: "\(getBaseRequestURL())/todos/\(withId)") {
            data, error in
            if error != nil { print(error?.localizedDescription) } else {
                do {
                    let json = try NSJSONSerialization.jsonObject(with: data,
                                                                  options: .mutableContainers)
                    item = self.parseItem(item: json)
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
        }

        return item

    }

    // Loads todolist from url

    func get() {

        router.HTTPGet(url: getBaseRequestURL()) {
            data, error in
            if error != nil { print(error?.localizedDescription) } else {
                do {
                    let json = try NSJSONSerialization.jsonObject(with: data,
                                                                  options: .mutableContainers)
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

    private func parseTodoList(json: AnyObject) {

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
                      titleValue = title,
                      completedValue = completed,
                      orderValue = order else {

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

    func move(itemAt: NSIndexPath, to: NSIndexPath) {

        var itemToMove = allTodos[itemAt.row]

        itemToMove.order = allTodos[to.row].order

        allTodos.remove(at: itemAt.row)
        allTodos.insert(itemToMove, at: to.row)

        // Update order on server
        TodoItemDataManager.sharedInstance.update(item: itemToMove)
    }
}
