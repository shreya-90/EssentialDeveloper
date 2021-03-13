//
//  RemoteFeedLoader.swift
//  EssentialFeedTests
//
//  Created by Shreya Pallan on 12/03/21.
//  Copyright © 2021 Shreya Pallan. All rights reserved.
//

import Foundation

public protocol HTTPClient {   // this is currently an abstract class and swift provides a better way of defining these                   interfaces - protocols
    func get(from url: URL,  completion : @escaping (Error?, HTTPURLResponse?) -> Void)
}

public final class RemoteFeedLoader {
    
    let client : HTTPClient
    let url : URL
    
    public enum Error : Swift.Error{
        case connectivity
        case invalidData
        
    }
    public init(url : URL  ,client:  HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion :  @escaping (Error) -> Void) {
       // HTTPClient.shared.get(from: URL(string: "https://a-url.com")!)   // locating the client & calling a function => violating SRP
        client.get(from: url) { error,response in
            
            if response != nil {
                completion(.invalidData)

            }else {
                completion(.connectivity)

            }
        } //problem solved
         //client.get(from: url) 
    }
}
