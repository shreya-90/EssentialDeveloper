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
                
                do {
                    let items =  try FeedMapper.map(data, response)
                    completion(.success(items))
                } catch {
                     completion(.failure(.invalidData))
                }
    
            case .failure:
                completion(.failure(.connectivity))
            }
            
        } //problem solved
         //client.get(from: url) 
    }
}





private class FeedMapper {
    
    private struct Root:Decodable {
        let items : [Item]
    }
    
    private struct Item : Decodable {
     
         let id : UUID
         let description : String?
         let location : String?
         let image : URL
        
        var item : FeedItem {
            return FeedItem(id: id, description: description, location: location, imageURL:image)
        }
      
        
    }
    
    static var OK_200 : Int { return 200 }
    
    static func map(_ data : Data, _ response : HTTPURLResponse) throws -> [FeedItem] {
        
         guard response.statusCode == OK_200 else {
                   throw RemoteFeedLoader.Error.invalidData
         }
               
         return try JSONDecoder().decode(Root.self, from: data).items.map({$0.item})
        
    }
    
}

