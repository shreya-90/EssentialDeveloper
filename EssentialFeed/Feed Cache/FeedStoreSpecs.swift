//
//  FeedStoreSpecs.swift
//  EssentialFeed
//
//  Created by Shreya Pallan on 20/05/21.
//  Copyright © 2021 Shreya Pallan. All rights reserved.
//

import Foundation
protocol FeedStoreSpecs {
    

     func test_retrieve_deliversEmptyOnEmptyCache()
     func test_retrieve_hasNoSideEffectsOnEmptyCache()
     func test_retrieve_deliversFoundValuesAfterInsertingToEmptyCache()
     func test_retrieve_hasNoSideEffectsOnNonEmptyCache()
     

     func test_insert_overridePreviouslyInsertedCacheValues()

     func test_delete_hasNoSideEffectsOnEmptyCache()
     func test_delete_emptiesPreviouslyInsertedCache()
     func test_delete_deliversErrorOnDeletionError()

     func test_storeSideEffects_runSerially()

}

protocol FailableRetrieveFeedStoreSpecs: FeedStoreSpecs {
    func test_retrieve_deliversFailureOnRetrievalError()
    func test_retrieve_hasNoSideEffectsOnFailure()
}

protocol FailableInsertFeedStoreSpecs: FeedStoreSpecs {
    func test_insert_deliversErrorOnInsertionError()
    func test_insert_hasNosideEffectsOnInsertionError()
}

protocol FailableDeleteFeedStoreSpecs: FeedStoreSpecs {
    func test_delete_deliversErrorOnDeletionError()
    func test_delete_hasNoSideEffectsOnDeletionError()
}

typealias FailableFeedStore = FailableRetrieveFeedStoreSpecs & FailableInsertFeedStoreSpecs & FailableDeleteFeedStoreSpecs
