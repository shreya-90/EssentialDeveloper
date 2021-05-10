//
//  LoadFeedFromCacheUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Shreya Pallan on 10/05/21.
//  Copyright © 2021 Shreya Pallan. All rights reserved.
//

import XCTest
import EssentialFeed

class LoadFeedFromCacheUseCaseTests: XCTestCase {

    func test_init_doesNotMessageStoreOnCreation() {
        
            let (_,store) = makeSUT()
            XCTAssertEqual(store.receivedMessages, [])
    }

    private func makeSUT(currentDate: @escaping () -> Date = Date.init ,file: StaticString = #file, line: UInt = #line) -> (sut: LocalFeedLoader,store: FeedStoreSpy) {
               let store = FeedStoreSpy()
               let sut = LocalFeedLoader(store:store,currentDate: currentDate)
               checkForMemoryLeaks(store,file: file,line: line)
               checkForMemoryLeaks(sut,file: file, line: line)

               return (sut,store)
       }
    
    
}

