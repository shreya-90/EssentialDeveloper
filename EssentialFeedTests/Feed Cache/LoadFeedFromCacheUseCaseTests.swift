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
    
    
    private class FeedStoreSpy: FeedStore {
        
        enum ReceivedMessage : Equatable {
            case deleteCacheFeed
            case insert([LocalFeedImage],Date)
        }
        
        private(set) var receivedMessages = [ReceivedMessage]()
        
        private var deletionCompletions = [DeletionCompletion]()
        private var insertionCompletions = [InsertionCompletion]()
        
        func deleteCachedFeed(completion : @escaping DeletionCompletion){
            deletionCompletions.append(completion)
            receivedMessages.append(.deleteCacheFeed)
        }
        
        func completeDeletion(with error: Error , at index: Int = 0){
            deletionCompletions[index](error)
        }
        func completeInsertion(with error: Error , at index: Int = 0){
            insertionCompletions[index](error)
        }
        
        func completeDeletionSuccessfully(at index: Int = 0) {
             deletionCompletions[index](nil)
        }
        
        func insert(_ feed: [LocalFeedImage], timestamp : Date, completion : @escaping InsertionCompletion){
            receivedMessages.append(.insert(feed, timestamp))
            insertionCompletions.append(completion)
        }
        
        func completeInsertionSuccessfully(at index: Int = 0) {
             insertionCompletions[index](nil)
        }
    }
}

