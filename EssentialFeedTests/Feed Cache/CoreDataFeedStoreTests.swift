//
//  CoreDataFeedStoreTests.swift
//  EssentialFeedTests
//
//  Created by Shreya Pallan on 21/05/21.
//  Copyright © 2021 Shreya Pallan. All rights reserved.
//

import XCTest
import EssentialFeed

class CoreDataFeedStoreTests: XCTestCase, FeedStoreSpecs {
    
    
    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = makeSUT()
<<<<<<< HEAD
        
=======

>>>>>>> feature/image-feed/cache-feed-usecase
        assertThatRetrieveDeliversEmptyOnEmptyCache(on: sut)
    }
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
<<<<<<< HEAD
         let sut = makeSUT()
        
=======
        let sut = makeSUT()

>>>>>>> feature/image-feed/cache-feed-usecase
        assertThatRetrieveHasNoSideEffectsOnEmptyCache(on: sut)
    }
    
    func test_retrieve_deliversFoundValuesAfterInsertingToEmptyCache() {
        let sut = makeSUT()

        assertThatRetrieveDeliversFoundValuesOnNonEmptyCache(on: sut)
    }
    
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {
        let sut = makeSUT()

        assertThatRetrieveHasNoSideEffectsOnNonEmptyCache(on: sut)
    }
    
    func test_insert_overridePreviouslyInsertedCacheValues() {
        let sut = makeSUT()

        assertThatInsertOverridesPreviouslyInsertedCacheValues(on: sut)
    }
    
    func test_insert_deliversNoErrorOnEmptyCache() {

        let sut = makeSUT()

        assertThatInsertDeliversNoErrorOnEmptyCache(on: sut)
    }
    func test_insert_deliversNoErrorOnNonEmptyCache() {
        let sut = makeSUT()

        assertThatInsertDeliversNoErrorOnNonEmptyCache(on: sut)
    }
    
    func test_delete_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()

        assertThatDeleteHasNoSideEffectsOnEmptyCache(on: sut)
    }
    
    func test_delete_emptiesPreviouslyInsertedCache() {
        let sut = makeSUT()

        assertThatDeleteEmptiesPreviouslyInsertedCache(on: sut)
    }
    
    func test_delete_deliversNoErrorOnNonEmptyCache() {

        let sut = makeSUT()

        assertThatDeleteDeliversNoErrorOnNonEmptyCache(on: sut)
    }
    
    func test_delete_deliversErrorOnDeletionError() {
        
    }
    
    func test_storeSideEffects_runSerially() {
        let sut = makeSUT()

        assertThatSideEffectsRunSerially(on: sut)
    }
    
<<<<<<< HEAD
    //MARK: - Helpers
    
    func makeSUT(storeURL: URL? = nil,file: StaticString = #file, line: UInt = #line) -> FeedStore {
        let sut = CoreDataFeedStore()
        checkForMemoryLeaks(sut,file: file,line: line)
=======
    // - MARK: Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> FeedStore {
        let storeBundle = Bundle(for: CoreDataFeedStore.self)
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try! CoreDataFeedStore(storeURL: storeURL, bundle: storeBundle)
        checkForMemoryLeaks(sut, file: file, line: line)
>>>>>>> feature/image-feed/cache-feed-usecase
        return sut
    }


}
