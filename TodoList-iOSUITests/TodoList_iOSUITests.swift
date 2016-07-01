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

import XCTest

class TodoListUITests: XCTestCase {

    override func setUp() {
        super.setUp()

        // Put setup code here. This method is
        // called before the invocation of each test method in the class.
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup
        // will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state -
        // such as interface orientation - required for your
        // tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after
        // the invocation of each test method in the class.
        super.tearDown()
    }

    func addElement() {

        
        let app = XCUIApplication()
        app.buttons["SIGN IN WITH FACEBOOK"].tap()
        app.webViews.textFields["Email or Phone"]

        
        
        /*let app = XCUIApplication()
        // Add Element
        app.navigationBars["TodoList_iOS.TodoTableView"].buttons["Add"].tap()
        let field = app.textFields["What needs to be done?"]
        field.tap()
        field.typeText("TodoItem 1")
        app.navigationBars["Add Todo Item"].buttons["Done"].tap()

        sleep(1)

        app.navigationBars["TodoList_iOS.TodoTableView"].buttons["Add"].tap()
        let textField = app.textFields["What needs to be done?"]
        textField.tap()
        textField.typeText("TodoItem 2")
        app.navigationBars["Add Todo Item"].buttons["Done"].tap()

        // Check Mark

        let table = app.tables.element
        let item1 = table.cells.element(boundBy: 1)
        let item2 = table.cells.element(boundBy: 2)
        XCTAssert(item1.exists && item2.exists, "Could not add cells to the table")
        XCTAssert(item1.label == "Test 1" && item2.label == "Test 2", "Added Cells Incorrectly")
        table.staticTexts["Test 1"].tap()

        let todolistIosTodotableviewNavigationBar = app.navigationBars["TodoList_iOS.TodoTableView"]
        let allButton = todolistIosTodotableviewNavigationBar.buttons["All"]
        allButton.tap()
        table.staticTexts["5"].tap()
        table.staticTexts["2"].tap()
        table.buttons["Delete"].tap()
        todolistIosTodotableviewNavigationBar.buttons["Todo"].tap()
        allButton.tap()*/

        // Delete
    }
}
