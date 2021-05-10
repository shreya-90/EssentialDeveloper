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
    
    func test_load_requestsCacheRetrieval(){
        let (sut,store) = makeSUT()
        
        sut.load() { _ in }
        
        XCTAssertEqual(store.receivedMessages, [.retrieval])
        
    }
    
    func test_load_failsOnRetrievalError() {
        let (sut,store) = makeSUT()
        var receivedError : Error?
        var retrievalError = anyNSError()
        
        let exp = expectation(description: "Wait for load to complete ... ")
        sut.load() { error in
            receivedError = error
            exp.fulfill()
        }
        
        store.completeRetrieval(with: retrievalError)
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(retrievalError as NSError? , retrievalError)

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

