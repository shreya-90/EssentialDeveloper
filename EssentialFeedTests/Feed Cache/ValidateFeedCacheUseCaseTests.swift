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
    
    func test_validatesCache_doesNotDeleteCacheOnEmptyCache(){
            let (sut,store) = makeSUT()

            sut.validatesCache()
            store.completeRetrievalWithEmptyCache()

            XCTAssertEqual(store.receivedMessages, [.retrieve])
        
    }
    
    func test_validatesCache_doesNotDeleteLessThanSevenDaysOldCache(){
            let feed = uniqueImageFeed()
            let fixedCurrentDate = Date()
            let lessThanSevenDaysOldTimestamp = fixedCurrentDate.adding(days: -7).adding(seconds: 1)
            let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })


            sut.validatesCache()
            store.completeRetrieval(with: feed.local, timestamp: lessThanSevenDaysOldTimestamp)

            XCTAssertEqual(store.receivedMessages, [.retrieve])
        
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

}

private extension Date {
    
    func adding(days:Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
    }
    
    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }
}
