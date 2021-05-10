//
//  FeedStore.swift
//  EssentialFeed
//
//  Created by Shreya Pallan on 03/05/21.
//  Copyright © 2021 Shreya Pallan. All rights reserved.
//

import Foundation

public protocol FeedStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    typealias RetrievalCompletion = (Error?) -> Void

    func deleteCachedFeed(completion : @escaping DeletionCompletion)
    func insert(_ feed: [LocalFeedImage], timestamp : Date, completion : @escaping InsertionCompletion)
    func retrieve(completion : @escaping RetrievalCompletion)
}







