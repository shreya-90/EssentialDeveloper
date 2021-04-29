//
//  CacheFeedUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Shreya Pallan on 29/04/21.
//  Copyright © 2021 Shreya Pallan. All rights reserved.
//

import XCTest


class LocalFeedLoader {
    init(store:FeedStore) {
        
    }
}
class FeedStore {
    var deleteCachedFeedCallCount = 0
}

class CacheFeedUseCaseTests: XCTestCase {

    func test_init_doesNotDeleteCacheOnCreation() {
        
        let store = FeedStore()
        _ = LocalFeedLoader(store:store)
        XCTAssertEqual(store.deleteCachedFeedCallCount, 0)
    }
}
