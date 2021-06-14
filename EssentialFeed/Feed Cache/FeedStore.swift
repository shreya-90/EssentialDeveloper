//
//  FeedStore.swift
//  EssentialFeed
//
//  Created by Shreya Pallan on 03/05/21.
//  Copyright © 2021 Shreya Pallan. All rights reserved.
//

import Foundation



public enum CachedFeed {
    case empty
    case found(feed: [LocalFeedImage], timestamp: Date)
}

public protocol FeedStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    
    typealias RetrievalResult = Swift.Result<CachedFeed,Error>
    typealias RetrievalCompletion = (RetrievalResult) -> Void

    ///The completion handlers can be invoked in any thread, if needed.
    ///Clients are responsible to dispatch to appropriate threads, if needed.
    func deleteCachedFeed(completion : @escaping DeletionCompletion)
    
    ///The completion handlers can be invoked in any thread, if needed.
    ///Clients are responsible to dispatch to appropriate threads, if needed.
    func insert(_ feed: [LocalFeedImage], timestamp : Date, completion : @escaping InsertionCompletion)
    
    ///The completion handlers can be invoked in any thread, if needed.
    ///Clients are responsible to dispatch to appropriate threads, if needed.
    func retrieve(completion : @escaping RetrievalCompletion)
}







