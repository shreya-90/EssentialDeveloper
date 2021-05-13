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

    
    
    //MARK: - Helpers

    private func makeSUT(currentDate: @escaping () -> Date = Date.init ,file: StaticString = #file, line: UInt = #line) -> (sut: LocalFeedLoader,store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store:store,currentDate: currentDate)
        checkForMemoryLeaks(store,file: file,line: line)
        checkForMemoryLeaks(sut,file: file, line: line)

        return (sut,store)
    }
       
    private func anyNSError() -> NSError {
      return NSError(domain: "any Error", code: 0)
    }

}
