//
//  FeedItemsMapper.swift
//  EssentialFeed
//
//  Created by Shreya Pallan on 03/04/21.
//  Copyright © 2021 Shreya Pallan. All rights reserved.
//

import Foundation

internal struct RemoteFeedItem : Decodable {
    
     internal let id : UUID
     internal let description : String?
     internal let location : String?
     internal let image : URL
}

internal final class FeedItemsMapper {
    
    private struct Root:Decodable {
        let items : [RemoteFeedItem]
    }
    
    private static var OK_200 : Int { return 200 }
    
//    internal static func map(_ data : Data, _ response : HTTPURLResponse) throws -> [FeedItem] {
//        
//         guard response.statusCode == OK_200 else {
//                   throw RemoteFeedLoader.Error.invalidData
//         }
//               
//         return try JSONDecoder().decode(Root.self, from: data).items.map({$0.item})
//        
//    }
    
    internal static func map(_ data: Data, _ response : HTTPURLResponse) throws -> [RemoteFeedItem] {
         
        guard response.statusCode == OK_200,
        let root =  try? JSONDecoder().decode(Root.self, from: data) else {
//                throw RemoteFeedLoader.Error.invalidData
            throw RemoteFeedLoader.Error.invalidData
        }
        
        return root.items
         
     }
}
