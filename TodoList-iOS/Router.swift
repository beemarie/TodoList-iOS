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
import FBSDKCoreKit

class Router: NSObject {

    let session = NSURLSession.shared()

    /*
        Method: Constructs an HTTP GET request to the destination url
     */

    func onGet(url: String, callback: (NSData?, NSError?) -> Void) {

        let request: NSMutableURLRequest = NSMutableURLRequest()

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(FBSDKAccessToken.current().tokenString, forHTTPHeaderField: "access_token")
        request.setValue("FacebookToken", forHTTPHeaderField: "X-token-type")

        request.url = NSURL(string: url)!
        request.httpMethod = "GET"

        taskManager(request: request) { data, error in
            callback(data, error)
        }
    }

    /*
        Method: Constructs an HTTP POST request to the destination url
        containing the given json serializable object
     */

    func onPost(url: String,
                  jsonString: AnyObject,
                  callback: (NSData?, NSError?) -> Void) {

        let request = buildRequest()

        request.url = NSURL(string: url)!
        request.httpMethod = "POST"
        request.httpBody = jsonString.data(using: NSUTF8StringEncoding)!

        taskManager(request: request) { data, error in
            callback(data, error)
        }

    }

    /*
        Method: Constructs an HTTP Patch request to the destination url
        containing the given json serializable object
     */

    func onPatch(url: String,
                   jsonString: AnyObject,
                   callback: (NSData?, NSError?) -> Void) {

        let request = buildRequest()

        request.url = NSURL(string: url)!
        request.httpMethod = "PATCH"
        request.httpBody = jsonString.data(using: NSUTF8StringEncoding)!

        taskManager(request: request) { data, error in
            callback(data, error)
        }

    }

    /*
        Method: Constructs an HTTP Delete request to the destination url
        containing the given json serializable object
     */

    func onDelete(url: String, callback: (NSData?, NSError?) -> Void) {

        let request = buildRequest()

        request.url = NSURL(string: url)!
        request.httpMethod = "DELETE"

        taskManager(request: request) { data, error in
            callback(data, error)
        }
    }

    /*
        Method: Executes the current http request asynchronously
     */

    func taskManager(request: NSMutableURLRequest, callback: (NSData?, NSError?) -> Void) {

        let task = session.dataTask(with: request as NSURLRequest) {
            data, response, error in

            dispatch_async(dispatch_get_main_queue()) {
                UIApplication.shared().isNetworkActivityIndicatorVisible = false
            }

            if let error = error {
                print(error.localizedDescription)

            } else if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    callback(data, error)
                }
            }


        }

        task.resume()
    }

    private func buildRequest() -> NSMutableURLRequest {

        let request: NSMutableURLRequest = NSMutableURLRequest()

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(FBSDKAccessToken.current().tokenString, forHTTPHeaderField: "access_token")
        request.setValue("FacebookToken", forHTTPHeaderField: "X-token-type")

        return request
    }
}
