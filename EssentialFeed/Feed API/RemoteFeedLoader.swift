//
//  RemoteFeedLoader.swift
//  EssentialFeedTests
//
//  Created by Shreya Pallan on 12/03/21.
//  Copyright © 2021 Shreya Pallan. All rights reserved.
//

import Foundation


public final class RemoteFeedLoader : FeedLoader{
    
    let client : HTTPClient
    let url : URL
    
    public enum Error : Swift.Error{
        case connectivity
        case invalidData
        
    }
    
    public typealias Result = LoadFeedResult   //doemain error type
    
//    public enum Result : Equatable {
//        case success([FeedImage])
//        case failure(Error)
//    }
    
    public init(url : URL  ,client:  HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion :  @escaping (Result) -> Void) {
       // HTTPClient.shared.get(from: URL(string: "https://a-url.com")!)   // locating the client & calling a function => violating SRP
        client.get(from: url) { [weak self] result in
            
            guard self != nil else { return }
            
            switch result {
            case let .success(data, response):
                completion(RemoteFeedLoader.map(data, from: response))
            case .failure:
                completion(.failure(RemoteFeedLoader.Error.connectivity))
            }
            
        } //problem solved
         //client.get(from: url) 
    }
    
    private static func map(_ data:Data, from response : HTTPURLResponse) -> Result {
        do {
            let items = try FeedImagesMapper.map(data, response)
                return .success(items.toModels())
        }catch {
            return .failure(error)
        }
    }
 
}


private extension Array where Element == RemoteFeedImage {
    
    func toModels() -> [FeedImage] {
        return map {FeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.image)}
    }
}









