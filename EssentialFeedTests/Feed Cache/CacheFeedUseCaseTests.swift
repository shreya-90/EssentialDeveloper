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
    private let store: FeedStore
    private let currentDate: () -> Date
    
    init(store: FeedStore,currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
    
    func save(_ items: [FeedItem]){
        store.deleteCachedFeed { [unowned self] error in
            if error == nil {
                self.store.insert(items,timestamp: self.currentDate())
            }
        }
    }
}
class FeedStore {
    
    typealias DeletionCompletion = (Error?) -> Void
    
    enum ReceivedMessage : Equatable {
        case deleteCacheFeed
        case insert([FeedItem],Date)
    }
    
    private(set) var receivedMessages = [ReceivedMessage]()
    
    private var deletionCompletions = [DeletionCompletion]()
    
    func deleteCachedFeed(completion : @escaping DeletionCompletion){
        deletionCompletions.append(completion)
        receivedMessages.append(.deleteCacheFeed)
    }
    
    func completeDeletion(with error: Error , at index: Int = 0){
        deletionCompletions[index](error)
    }
    
    func completeDeletionSuccessfully(at index: Int = 0) {
         deletionCompletions[index](nil)
    }
    
    func insert(_ items: [FeedItem], timestamp : Date){
        receivedMessages.append(.insert(items, timestamp))
    }
}

class CacheFeedUseCaseTests: XCTestCase {

    func test_init_doesNotMessageStoreOnCreation() {
        
         let (_,store) = makeSUT()
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_save_requestCacheDeletion() {
        
        let (sut,store) = makeSUT()
        let items = [uniqueItem(),uniqueItem()]
        sut.save(items)
        
        XCTAssertEqual(store.receivedMessages, [.deleteCacheFeed])
    }
    
    func test_save_doesNotRequestCacheInsertionOnDeletionError(){
        let (sut,store) = makeSUT()
        let items = [uniqueItem(),uniqueItem()]
        
        sut.save(items)
        let deletionError = anyNSError()
        store.completeDeletion(with: deletionError)
        
        XCTAssertEqual(store.receivedMessages, [.deleteCacheFeed])
    }
    

    
    func test_save_requestsNewCacheInsertionWithTimestampOnSuccessfulDeletion(){
        
        let timestamp = Date()
        let (sut,store) = makeSUT(currentDate:{ timestamp })
        let items = [uniqueItem(),uniqueItem()]

        sut.save(items)
        store.completeDeletionSuccessfully()

//        XCTAssertEqual(store.insertCallCount, 1)
//        XCTAssertEqual(store.insertions.count, 1)
//        XCTAssertEqual(store.insertions.first?.items, items)
//        XCTAssertEqual(store.insertions.first?.timestamp, timestamp)
        
        XCTAssertEqual(store.receivedMessages, [.deleteCacheFeed,.insert(items,timestamp)])   // testing which messages were invoks, in which order and which values!!!

    }
    
    //MARK: - Helper methods
    
    private func makeSUT(currentDate: @escaping () -> Date = Date.init ,file: StaticString = #file, line: UInt = #line) -> (sut: LocalFeedLoader,store: FeedStore) {
        let store = FeedStore()
        let sut = LocalFeedLoader(store:store,currentDate: currentDate)
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
