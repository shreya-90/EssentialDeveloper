//
//  LocalFeedItem.swift
//  EssentialFeed
//
//  Created by Shreya Pallan on 08/05/21.
//  Copyright © 2021 Shreya Pallan. All rights reserved.
//

import Foundation


public struct LocalFeedItem : Equatable {
    
   public let id : UUID
    public let description : String?
    public let location : String?
    public let imageURL : URL
    
    
    public init(id: UUID, description: String?, location: String?, imageURL: URL) {
        self.id = id
        self.description = description
        self.location = location
        self.imageURL = imageURL
    }
}

extension LocalFeedItem : Decodable {
        private enum CodingKeys: String, CodingKey {
            case id
            case description
            case location
            case imageURL = "image"
        }
}
