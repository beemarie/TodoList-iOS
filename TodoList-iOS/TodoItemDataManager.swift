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

protocol TodoItemsDelegate {
    func onItemsAddedToList()
}

enum DataMangerError: ErrorProtocol {
    case CannotSerializeToJSON
    case DataNotFound
}

class TodoItemDataManager: NSObject {

    let router = Router()

    let config = BluemixConfiguration()

    static let sharedInstance = TodoItemDataManager()

    var delegate: TodoItemsDelegate?
    var allTodos: [[TodoItem]] = [[], []]

    private override init() {
        super.init()

        get()
    }

}

// MARK: Methods for storing, deleting, updating, and retrieving
extension TodoItemDataManager {

    // Store item in todolist
    func add(withTitle: String) {
        let json = self.json(withTitle: withTitle,
                             order: TodoItemDataManager.sharedInstance.allTodos[0].count + 1)

        router.onPost(url: getBaseRequestURL(), jsonString: json) {
            response, error in

            if error != nil {
                print(error?.localizedDescription)
            } else {

                guard let data = response else {
                    print(DataMangerError.DataNotFound)
                    return
                }

                do {
                    let json = try NSJSONSerialization.jsonObject(with: data,
                                                                  options: .mutableContainers)
                    self.allTodos[0].append(self.parseItem(item: json)!)

                    self.delegate?.onItemsAddedToList()

                } catch {
                    print(DataMangerError.CannotSerializeToJSON)

                }
            }
        }
    }

    func delete(itemAt: NSIndexPath) {

        let id = allTodos[itemAt.section][itemAt.row].id
        self.allTodos[itemAt.section].remove(at: itemAt.row)

        router.onDelete(url: "\(getBaseRequestURL())/todos/\(id)") {
            response, error in

            if error != nil { print(error?.localizedDescription) }
        }
    }

    func update(item: TodoItem) {

        router.onPatch(url: "\(getBaseRequestURL())/todos/\(item.id)",
                       jsonString: item.jsonRepresentation) {
            response, error in

            if error != nil { print(error?.localizedDescription) }
        }

    }

    func get(withId: String) -> TodoItem? {

        var item: TodoItem? = nil

        router.onGet(url: "\(getBaseRequestURL())/todos/\(withId)") {
            response, error in

            if error != nil { print(error?.localizedDescription) } else {

                guard let data = response else {
                    print(DataMangerError.DataNotFound)
                    return
                }

                do {
                    let json = try NSJSONSerialization.jsonObject(with: data,
                                                                  options: .mutableContainers)
                    item = self.parseItem(item: json)
                    self.delegate?.onItemsAddedToList()
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
        }

        return item

    }

    // Loads all TodoItems from designated base url

    func get() {

        router.onGet(url: getBaseRequestURL()) {
            response, error in

            if error != nil { print(error?.localizedDescription) } else {

                guard let data = response else {
                    print(DataMangerError.DataNotFound)
                    return
                }

                do {
                    let json = try NSJSONSerialization.jsonObject(with: data,
                                                                  options: .mutableContainers)
                    self.parseTodoList(json: json)
                    self.delegate?.onItemsAddedToList()
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

// Methods for Parsing Functions
extension TodoItemDataManager {

    private func parseTodoList(json: AnyObject) {

        allTodos[0].removeAll()
        allTodos[1].removeAll()

        if let json = json as? [AnyObject] {

            for item in json {

                guard let todo = parseItem(item: item) else {
                    continue
                }
                if todo.completed == false {
                    insertInOrder(seq: &allTodos[0], newItem: todo)
                } else {
                    insertInOrder(seq: &allTodos[1], newItem: todo)
                }
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

            return TodoItem(id: uid, title: titleValue,
                            completed: completedValue, order: orderValue)
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

    func insertInOrder<T: Comparable>( seq: inout [T], newItem item: T) {
        let index = seq.reduce(0) { $1 < item ? $0 + 1 : $0 }
        seq.insert(item, at: index)
    }

    func move(itemAt: NSIndexPath, to: NSIndexPath) {

        var itemToMove = allTodos[itemAt.section][itemAt.row]

        itemToMove.order = allTodos[to.section][to.row].order

        allTodos[itemAt.section].remove(at: itemAt.row)
        allTodos[itemAt.section].insert(itemToMove, at: to.row)

        self.update(item: itemToMove)
    }

    func json(withTitle: String, order: Int) -> String {
        return "{\"title\":\"\(withTitle)\",\"completed\":\"\(false)\",\"order\":\"\(order)\"}"
    }

    func updateCompletion(indexPath: NSIndexPath) {
        var item = allTodos[indexPath.section].remove(at: indexPath.row)

        item.completed = !item.completed

        if item.completed == false {
            allTodos[0].append(item)
        } else {
            allTodos[1].append(item)
        }

        TodoItemDataManager.sharedInstance.update(item: item)
    }
}
