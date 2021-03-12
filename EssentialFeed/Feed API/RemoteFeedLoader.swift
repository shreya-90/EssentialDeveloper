//
//  RemoteFeedLoader.swift
//  EssentialFeedTests
//
//  Created by Shreya Pallan on 12/03/21.
//  Copyright © 2021 Shreya Pallan. All rights reserved.
//

import Foundation

public protocol HTTPClient {   // this is currently an abstract class and swift provides a better way of defining these                   interfaces - protocols
   func get(from url: URL)
}

public final class RemoteFeedLoader {
    
    let client : HTTPClient
    let url : URL
    
    public init(url : URL  ,client:  HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load() {
       // HTTPClient.shared.get(from: URL(string: "https://a-url.com")!)   // locating the client & calling a function => violating SRP
       client.get(from: url)  //problem solved
        
    }
}
