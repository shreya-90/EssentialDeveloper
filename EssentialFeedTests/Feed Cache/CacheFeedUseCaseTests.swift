//
//  CacheFeedUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Shreya Pallan on 29/04/21.
//  Copyright © 2021 Shreya Pallan. All rights reserved.
//

import XCTest
import EssentialFeed

class LocalFeedLoader {
    private let store : FeedStore
    
    init(store:FeedStore) {
        self.store = store
    }
    
    func save(_ items : [FeedItem]){
        store.deleteCachedFeed()
    }
}
class FeedStore {
    var deleteCachedFeedCallCount = 0
    var insertCallCount = 0
    
    func deleteCachedFeed(){
        deleteCachedFeedCallCount += 1
    }
    
    func completeDeletion(with error : Error , at index : Int = 0){
        
    }
}

class CacheFeedUseCaseTests: XCTestCase {

    func test_init_doesNotDeleteCacheOnCreation() {
        
         let (_,store) = makeSUT()
        XCTAssertEqual(store.deleteCachedFeedCallCount, 0)
    }
    
    func test_save_requestCacheDeletion() {
        
        let (sut,store) = makeSUT()
        let items = [uniqueItem(),uniqueItem()]
        sut.save(items)
        
        XCTAssertEqual(store.deleteCachedFeedCallCount, 1)
    }
    
    func test_save_doesNotRequestCacheInsertionOnDeletionError(){
        let (sut,store) = makeSUT()
        let items = [uniqueItem(),uniqueItem()]
        
        sut.save(items)
        let deletionError = anyNSError()
        store.completeDeletion(with: deletionError)
        
        XCTAssertEqual(store.insertCallCount, 0)
    }
    
    //MARK: - Helper methods
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: LocalFeedLoader,store:FeedStore) {
        let store = FeedStore()
        let sut = LocalFeedLoader(store:store)
        checkForMemoryLeaks(store,file: file,line: line)
        checkForMemoryLeaks(sut,file: file, line: line)

        return (sut,store)
    }
    
    private func uniqueItem() -> FeedItem {
        return FeedItem(id: UUID(), description: "any", location: "any", imageURL: anyURL() )
    }
    
    private func anyURL() -> URL {
            return  URL(string: "http://any-url.com")!
    }
    
    private func anyNSError() -> Error {
           return NSError(domain: "any Error", code: 0)
       }
}
