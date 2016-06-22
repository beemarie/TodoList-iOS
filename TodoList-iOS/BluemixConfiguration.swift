//
//  BluemixConfiguration.swift
//  TodoList-iOS
//
//  Created by Aaron Liberatore on 6/22/16.
//  Copyright © 2016 Swift@IBM Engineering. All rights reserved.
//

import UIKit

class BluemixConfiguration: NSObject {
    
    //Plist Keys
    private let kBluemixKeysPlistName = "bluemix"
    private let kIsLocalKey = "isLocal"
    private let kAppRouteLocal = "appRouteLocal"
    private let kAppRouteRemote = "appRouteRemote"
    private let kBluemixAppGUIDKey = "bluemixAppGUID"
    private let kBluemixAppRegionKey = "bluemixAppRegion"

    
    var isLocal: Bool = true
    let appGUID: String
    let appRegion: String
    let localBaseRequestURL: String
    let remoteBaseRequestURL: String
    
    override init() {
        
        if let path = NSBundle.main().pathForResource(kBluemixKeysPlistName, ofType: "plist"),
               plist = NSDictionary(contentsOfFile: path),
               isLocal              = plist[kIsLocalKey] as? Bool,
               appGUID              = plist[kBluemixAppGUIDKey] as? String,
               appRegion            = plist[kBluemixAppRegionKey] as? String,
               localBaseRequestURL  = plist[kAppRouteLocal] as? String,
               remoteBaseRequestURL = plist[kAppRouteRemote] as? String
            
        {

            self.isLocal = isLocal
            self.appGUID = appGUID
            self.appRegion = appRegion
            self.localBaseRequestURL = localBaseRequestURL
            self.remoteBaseRequestURL = remoteBaseRequestURL

            super.init()
            
        }
        else {
            fatalError("Could not load bluemix plist into object properties")
        }
    }
    
}
