//
//  HttpClient.swift
//  EssentialFeed
//
//  Created by Shreya Pallan on 24/03/21.
//  Copyright © 2021 Shreya Pallan. All rights reserved.
//

import Foundation



public protocol HTTPClient {   // this is currently an abstract class and swift provides a better way of defining these                   interfaces - protocols
    typealias Result = Swift.Result<(Data,HTTPURLResponse),Error>
    
    ///The completion handlers can be invoked in any thread, if needed.
    ///Clients are responsible to dispatch to appropriate threads, if needed.
    func get(from url: URL,  completion : @escaping (Result) -> Void)
}
