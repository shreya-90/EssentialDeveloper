//
//  ValidateFeedCacheUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Shreya Pallan on 13/05/21.
//  Copyright © 2021 Shreya Pallan. All rights reserved.
//

import XCTest

class ValidateFeedCacheUseCaseTests: XCTestCase {

    func test_init_doesNotMessageStoreOnCreation() {
     
         let (_,store) = makeSUT()
         XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_validatesCache_deletesCacheOnRetrievalError(){
        let (sut,store) = makeSUT()

        sut.validatesCache()
        store.completeRetrieval(with: anyNSError())

        XCTAssertEqual(store.receivedMessages, [.retrieve,.deleteCachedFeed])

    }
    
    func test_validatesCache_doesNotDeleteCacheOnEmptyCache(){
            let (sut,store) = makeSUT()

            sut.validatesCache()
            store.completeRetrievalWithEmptyCache()

            XCTAssertEqual(store.receivedMessages, [.retrieve])
        
    }
    
    func test_validatesCache_doesNotDeleteNonExpiredCache(){
            let feed = uniqueImageFeed()
            let fixedCurrentDate = Date()
            let nonExpiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: 1)
            let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })


            sut.validatesCache()
            store.completeRetrieval(with: feed.local, timestamp: nonExpiredTimestamp)

            XCTAssertEqual(store.receivedMessages, [.retrieve])
        
    }
    
    func test_validatesCache_deletesCacheOnExpiration(){
               let feed = uniqueImageFeed()
               let fixedCurrentDate = Date()
               let expirationTimestamp = fixedCurrentDate.minusFeedCacheMaxAge()
               let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })


               sut.validatesCache()

               store.completeRetrieval(with: feed.local, timestamp: expirationTimestamp)

           XCTAssertEqual(store.receivedMessages, [.retrieve,.deleteCachedFeed])
           
       }
    
    func test_validatesCache_deletesExpiredCache(){
            let feed = uniqueImageFeed()
            let fixedCurrentDate = Date()
            let expiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: -1)
            let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })


            sut.validatesCache()

            store.completeRetrieval(with: feed.local, timestamp: expiredTimestamp)

            XCTAssertEqual(store.receivedMessages, [.retrieve,.deleteCachedFeed])
        
    }
    
    
    func test_validatesCache_doesNotDeleteInvalidCacheAfterSUTInstanceHasBeenDeallocated(){
        let store = FeedStoreSpy()
        var sut: LocalFeedLoader? = LocalFeedLoader(store: store, currentDate: Date.init)

        sut?.validatesCache()
        sut = nil
        store.completeRetrieval(with: anyNSError())

        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    //MARK: - Helpers

    private func makeSUT(currentDate: @escaping () -> Date = Date.init ,file: StaticString = #file, line: UInt = #line) -> (sut: LocalFeedLoader,store: FeedStoreSpy) {
            let store = FeedStoreSpy()
            let sut = LocalFeedLoader(store:store,currentDate: currentDate)
            checkForMemoryLeaks(store,file: file,line: line)
            checkForMemoryLeaks(sut,file: file, line: line)

            return (sut,store)
    }

}


