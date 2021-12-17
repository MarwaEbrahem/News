//
//  Utils.swift
//  NewsApp
//
//  Created by marwa on 12/17/21.
//  Copyright © 2021 marwa. All rights reserved.
//

import Foundation
import Alamofire

struct Connectivity {

    private init() {}
    static let sharedInstance = NetworkReachabilityManager()!
    static var isConnectedToInternet:Bool {
        return self.sharedInstance.isReachable
    }
}
