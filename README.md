# TodoList-iOS

An example using the Kitura web framework and HTTP Server to develop a backend for a iOS todo list organizer

[![Build Status](https://travis-ci.org/IBM-Swift/Kitura-TodoList.svg?branch=master)](https://travis-ci.org/IBM-Swift/todolist-ios)

> Supports the 05-03 SNAPSHOT.

## Quick start for running locally

1. Install the [05-03-DEVELOPMENT Swift toolchain](https://swift.org/download/)

2. Install Kitura dependencies:

  1. Mac OS X:

    `brew install curl`

3. Navigate to the `TodoList-Server` directory and Build/Run the TodoList Kitura backend
  - `build swift`
  - `./.build/debug/TodoList-Server`

4. Run Couchdb inside another terminal window
  - `couchdb`

5. Open `TodoList-iOS.xcodeproj` and build/run the simulator

## Deploy to BlueMix Automatically ##
Simply click the deploy to bluemix button and follow the prompts! (Currently the repo is not public so this feature is invalid)

[![Deploy to Bluemix](https://bluemix.net/deploy/button.png)](https://bluemix.net/deploy?repository=https://github.com/IBM-Swift/todolist-ios.git)

## Deploying to BlueMix Manually##

1. Get an account for [Bluemix](https://new-console.ng.bluemix.net/?direct=classic)

2. Dowload and install the [Cloud Foundry tools](https://new-console.ng.bluemix.net/docs/starters/install_cli.html):

    ```
    cf login
    bluemix api https://api.ng.bluemix.net
    bluemix login -u username -o org_name -s space_name
    ```

    Be sure to change the directory to the TodoList-iOS directory where the manifest.yml file is located.

3. Run `cf push`

    Note: The uploading droplet stage should take a long time, roughly 4-6 minutes. If it worked correctly, it should say:

    ```
    1 of 1 instances running

    App started
    ```

4. Create the Cloudant backend and attach it to your instance.

    ```
    cf create-service cloudantNoSQLDB Shared database_name
    cf bind-service TodoList-iOS database_name
    cf restage
    ```

5. Create a new design in Cloudant

    Log in to Bluemix, and select New View. Create a new design called `_design/example`. Inside of the design example, create 2 views:

6. Create a view named `all_todos` in the example design:

    This view will return all of the todo elements in your database. Add the following Map function:

    ```javascript
    function(doc) {
        if (doc.type == 'todo' && doc.active) {
            emit(doc._id, [doc.title, doc.completed, doc.order]);
        }
    }
    ```

    Leave Reduce as None.

7. Create a view named `total_todos` in the example design:

    This view will return the count of all the todo documents in your database.

    ```javascript
    function(doc) {
        if (doc.type == 'todo' && doc.active) {
            emit(doc.id, 1);
        }
    }
    ```

    Set the reduce function to `_count` which will tally all of the returned documents.

8. Open `TodoList-iOS.xcodeproj` and build/run the simulator

## License

This library is licensed under Apache 2.0. Full license text is available in [LICENSE](LICENSE).
