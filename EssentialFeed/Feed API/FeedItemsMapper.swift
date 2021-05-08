//
//  FeedImagesMapper.swift
//  EssentialFeed
//
//  Created by Shreya Pallan on 03/04/21.
//  Copyright © 2021 Shreya Pallan. All rights reserved.
//

import Foundation

internal final class FeedImagesMapper {
    
    private struct Root:Decodable {
        let items : [RemoteFeedImage]
    }
    
    private static var OK_200 : Int { return 200 }
    
    internal static func map(_ data: Data, _ response : HTTPURLResponse) throws -> [RemoteFeedImage] {
         
        guard response.statusCode == OK_200,
        let root =  try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteFeedLoader.Error.invalidData
        }
        
        return root.items
         
     }
}
