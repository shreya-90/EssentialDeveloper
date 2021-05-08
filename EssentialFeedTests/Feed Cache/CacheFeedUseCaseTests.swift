//
//  CacheFeedUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Shreya Pallan on 29/04/21.
//  Copyright © 2021 Shreya Pallan. All rights reserved.
//

import XCTest
import EssentialFeed


class CacheFeedUseCaseTests: XCTestCase {

    func test_init_doesNotMessageStoreOnCreation() {
        
            let (_,store) = makeSUT()
            XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_save_requestCacheDeletion() {
        
            let (sut,store) = makeSUT()

            sut.save(uniqueImageFeed().model){_ in }

            XCTAssertEqual(store.receivedMessages, [.deleteCacheFeed])
    }
    
    func test_save_doesNotRequestCacheInsertionOnDeletionError(){
            let (sut,store) = makeSUT()

            sut.save(uniqueImageFeed().model){_ in }
            let deletionError = anyNSError()
            store.completeDeletion(with: deletionError)

            XCTAssertEqual(store.receivedMessages, [.deleteCacheFeed])
    }
    

    
    func test_save_requestsNewCacheInsertionWithTimestampOnSuccessfulDeletion(){
        
            let timestamp = Date()
            let (sut,store) = makeSUT(currentDate:{ timestamp })
            let feed = uniqueImageFeed()


            sut.save(feed.model){_ in }
            store.completeDeletionSuccessfully()

            //        XCTAssertEqual(store.insertCallCount, 1)
            //        XCTAssertEqual(store.insertions.count, 1)
            //        XCTAssertEqual(store.insertions.first?.items, items)
            //        XCTAssertEqual(store.insertions.first?.timestamp, timestamp)

            XCTAssertEqual(store.receivedMessages, [.deleteCacheFeed,.insert(feed.local,timestamp)])   // testing which messages were invoks, in which order and which values!!!

    }
    
    func test_save_failsOnDeletionError(){
            let (sut,store) = makeSUT()
            let items = [uniqueImage(),uniqueImage()]
            let deletionError = anyNSError()

            expect(sut, tocompleteWithError: deletionError, when: {
                 store.completeDeletion(with: deletionError)
            })
       }
    
    func test_save_failsOnInsertionError(){
            let (sut,store) = makeSUT()
            let items = [uniqueImage(),uniqueImage()]
            let insertionError = anyNSError()

            expect(sut, tocompleteWithError: insertionError, when: {
                store.completeDeletionSuccessfully()
                store.completeInsertion(with: insertionError)
            })
        
     
    }
    
    func test_save_succeedsOnSuccessfulCacheInsertion(){
            let (sut,store) = makeSUT()

            expect(sut, tocompleteWithError: nil, when: {
                store.completeDeletionSuccessfully()
                store.completeInsertionSuccessfully()
            })
    }
    
    func test_save_doesNotDeliverDeletionErrorAfterSUTInstanceHasBeenDeallocated(){
            var store = FeedStoreSpy()

            var sut: LocalFeedLoader?
            sut = LocalFeedLoader(store: store, currentDate: Date.init)

            var receivedResults = [LocalFeedLoader.SaveResult]()
            sut?.save(uniqueImageFeed().model){ receivedResults.append($0) }

            sut = nil
            store.completeDeletion(with: anyNSError())

            XCTAssertTrue(receivedResults.isEmpty)
    }
    
    func test_save_doesNotDeliverInsertionErrorAfterSUTInstanceHasBeenDeallocated(){
            var store = FeedStoreSpy()

            var sut: LocalFeedLoader?
            sut = LocalFeedLoader(store: store, currentDate: Date.init)


            var receivedResults = [LocalFeedLoader.SaveResult]()
            sut?.save(uniqueImageFeed().model){ receivedResults.append($0) }


            store.completeDeletionSuccessfully()
            sut = nil
            store.completeInsertion(with: anyNSError())


            XCTAssertTrue(receivedResults.isEmpty)
       }
    //MARK: - Helper methods
    
    private func makeSUT(currentDate: @escaping () -> Date = Date.init ,file: StaticString = #file, line: UInt = #line) -> (sut: LocalFeedLoader,store: FeedStoreSpy) {
            let store = FeedStoreSpy()
            let sut = LocalFeedLoader(store:store,currentDate: currentDate)
            checkForMemoryLeaks(store,file: file,line: line)
            checkForMemoryLeaks(sut,file: file, line: line)

            return (sut,store)
    }
    
    private func expect(_ sut: LocalFeedLoader, tocompleteWithError expectedError: NSError?, when action: () -> Void,file: StaticString = #file, line: UInt = #line){

            let exp = expectation(description: "Waiting for save completion ...")
            var receivedError : Error?

            sut.save(uniqueImageFeed().model) { error in
             receivedError  = error
             exp.fulfill()               //Make sure the block was invoked
            }

            action()

            wait(for: [exp], timeout: 1.0)
            XCTAssertEqual(receivedError as NSError?, expectedError)
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
    
    private func uniqueImage() -> FeedImage {
        return FeedImage(id: UUID(), description: "any", location: "any", url: anyURL() )
    }
    
    private func uniqueImageFeed() -> (model: [FeedImage],local: [LocalFeedImage]) {
         let models = [uniqueImage(),uniqueImage()]
        let local = models.map { LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url) }
        return (models,local)
    }
    
    private func anyURL() -> URL {
            return  URL(string: "http://any-url.com")!
    }
    
    private func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 0)
    }
}
