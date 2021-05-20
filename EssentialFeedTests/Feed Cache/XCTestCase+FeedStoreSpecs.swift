//
//  XCTestCase+FeedStoreSpecs.swift
//  EssentialFeedTests
//
//  Created by Shreya Pallan on 20/05/21.
//  Copyright © 2021 Shreya Pallan. All rights reserved.
//

import XCTest
import EssentialFeed

extension FeedStoreSpecs where Self: XCTestCase {
    
    func expect(_ sut: FeedStore, toRetrieve expectedResult: RetrieveCachedFeedResult,file: StaticString = #file, line: UInt = #line){
            let exp = expectation(description: "Wait for retrievel...")

            sut.retrieve { retrievedResult in

                switch (expectedResult,retrievedResult) {
                case (.empty,.empty),
                     (.failure,.failure):
                    break
                    
                case let (.found(expected),.found(retrieved)):
                    XCTAssertEqual(retrieved.feed, expected.feed,file:file,line:line)
                    XCTAssertEqual(retrieved.timestamp, expected.timestamp)
                    
                    default:
                        XCTFail("Expected to retrieve \(expectedResult), got \(retrievedResult) instead",file:file,line:line)
                    }
                
                exp.fulfill()
        }
         wait(for: [exp], timeout: 1.0)
    }
    
    func expect(_ sut: FeedStore, toRetrieveTwice expectedResult: RetrieveCachedFeedResult,file: StaticString = #file, line: UInt = #line){
            expect(sut,toRetrieve: expectedResult,file: file,line: line)
            expect(sut,toRetrieve: expectedResult,file: file,line: line)

    }
    
    @discardableResult
    func insert(_ cache: (feed: [LocalFeedImage], timestamp: Date), to sut: FeedStore) -> Error?{
            let exp = expectation(description: "Wait for cache insertion...")
            var insertionError : Error?
            sut.insert(cache.feed, timestamp: cache.timestamp) { receivedInsertionError in
                    insertionError = receivedInsertionError
                    exp.fulfill()
            }
            wait(for: [exp], timeout: 1.0)
            return insertionError
    }
    
    @discardableResult
    func deleteCache(_ sut: FeedStore)-> Error? {
            let exp = expectation(description: "Wait for cache deletion")
            
            var deletionError: Error?
            sut.deleteCachedFeed { receivedDeletionError in
                deletionError = receivedDeletionError
                exp.fulfill()
            }
            wait(for: [exp], timeout: 1.0)
            return deletionError
    }
}
