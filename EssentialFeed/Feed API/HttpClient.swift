//
//  HttpClient.swift
//  EssentialFeed
//
//  Created by Shreya Pallan on 24/03/21.
//  Copyright © 2021 Shreya Pallan. All rights reserved.
//

import Foundation

public enum HttpClientResult{
    case success(Data,HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {   // this is currently an abstract class and swift provides a better way of defining these                   interfaces - protocols
    func get(from url: URL,  completion : @escaping (HttpClientResult) -> Void)
}