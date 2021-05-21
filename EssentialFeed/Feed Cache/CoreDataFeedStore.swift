//
//  CoreDataFeedStore.swift
//  EssentialFeed
//
//  Created by Shreya Pallan on 21/05/21.
//  Copyright © 2021 Shreya Pallan. All rights reserved.
//

import Foundation


class CoreDataFeedStore: FeedStore {
    func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        
    }
    
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        
    }
    
    func retrieve(completion: @escaping RetrievalCompletion) {
        return completion(.empty)
    }
    
    
}
