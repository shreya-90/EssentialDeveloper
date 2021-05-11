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
        sut.load() { result in
            
            switch result {
                case let .failure(error):
                     receivedError = error
                
                default:
                    XCTFail("Exoected failure, got \(result) instead")
            }
            exp.fulfill()
        }
        
        store.completeRetrieval(with: retrievalError)
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(receivedError as NSError? , retrievalError)

    }
    
    func test_load_deliversNoImagesOnEmptyCache(){
        let (sut,store) = makeSUT()
        var receivedImages : [FeedImage]?

        let exp = expectation(description: "Wait for load to complete ... ")
        sut.load() { result in
            switch result {
            case let .success(images):
                receivedImages = images
            default :
                 XCTFail("Exoected success, got \(result) instead")
            }
           exp.fulfill()
        }

        store.completeRetrievalWithEmptyCache()
        wait(for: [exp], timeout: 1.0)

        XCTAssertEqual(receivedImages , [])
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

