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
        
        expect(sut, toCompleteWith: .failure(retrievalError), when: {
              store.completeRetrieval(with: retrievalError)
        })
        

    }
    
    func test_load_deliversNoImagesOnEmptyCache(){
        let (sut,store) = makeSUT()
        expect(sut, toCompleteWith: .success([]), when: {
             store.completeRetrievalWithEmptyCache()
        })
        
        
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
    
    private func expect(_ sut: LocalFeedLoader, toCompleteWith expectedResult: LocalFeedLoader.LoadResult, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let (sut,store) = makeSUT()

        let exp = expectation(description: "Wait for load to complete ... ")
        sut.load() { receivedResult in
            switch (receivedResult,expectedResult) {
            case let (.success(receivedImages), .success(expectedImages)):
                XCTAssertEqual(receivedImages, expectedImages,file:file, line:line)
            case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
                XCTAssertEqual(receivedError, expectedError,file:file, line:line)
                
            default :
                 XCTFail("Expected result \(expectedResult), got \(receivedResult) instead",file:file, line:line)
            }
           exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1.0)

    }
}

