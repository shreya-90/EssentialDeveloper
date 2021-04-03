//
//  RemoteFeedLoader.swift
//  EssentialFeedTests
//
//  Created by Shreya Pallan on 12/03/21.
//  Copyright © 2021 Shreya Pallan. All rights reserved.
//

import Foundation


public final class RemoteFeedLoader {
    
    let client : HTTPClient
    let url : URL
    
    public enum Error : Swift.Error{
        case connectivity
        case invalidData
        
    }
    
    public enum Result : Equatable {
        case success([FeedItem])
        case failure(Error)
    }
    
    public init(url : URL  ,client:  HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion :  @escaping (Result) -> Void) {
       // HTTPClient.shared.get(from: URL(string: "https://a-url.com")!)   // locating the client & calling a function => violating SRP
        client.get(from: url) { result in
            
            switch result {
            case let .success(data, response):
                completion(RemoteFeedLoader.map(data, response))  //retain cycle with self
            case .failure:
                completion(.failure(.connectivity))
            }
            
        } //problem solved
         //client.get(from: url) 
    }
    
    
    private static func map(_ data: Data, _ response : HTTPURLResponse) -> Result {
        
        do {
            let items =  try FeedItemsMapper.map(data, response)
            return .success(items)
        } catch {
             return .failure(.invalidData)
        }
    }
}









