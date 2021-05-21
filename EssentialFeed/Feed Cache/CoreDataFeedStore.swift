//
//  CoreDataFeedStore.swift
//  EssentialFeed
//
//  Created by Shreya Pallan on 21/05/21.
//  Copyright © 2021 Shreya Pallan. All rights reserved.
//

import Foundation

public final class CoreDataFeedStore: FeedStore {
    public init() {}
    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        
    }
    
    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        completion(.empty)
    }
    
}
