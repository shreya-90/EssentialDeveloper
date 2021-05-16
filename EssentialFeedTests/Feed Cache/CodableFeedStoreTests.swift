//
//  CodableFeedStoreTests.swift
//  EssentialFeedTests
//
//  Created by Shreya Pallan on 16/05/21.
//  Copyright © 2021 Shreya Pallan. All rights reserved.
//

import XCTest
import EssentialFeed


class CodableFeedStore {
    
    private struct Cache: Codable {
        let feed: [CodableFeedImage]
        let timestamp: Date
        
        var localFeed: [LocalFeedImage] {
            return feed.map { $0.local }
        }
    }
    
    private struct CodableFeedImage: Codable {
        private let id : UUID
        private let description : String?
        private let location : String?
        private let url : URL
        
        init(_ image: LocalFeedImage) {
            id = image.id
            description = image.description
            location = image.location
            url = image.url
        }
        
        var local: LocalFeedImage {
            return LocalFeedImage(id: id, description: description, location: location, url: url)
        }
    }
    
    private let storeURL: URL
    init(storeURL: URL){
        self.storeURL = storeURL
    }
    
    func retrieve(completion : @escaping FeedStore.RetrievalCompletion){
        guard let data = try? Data(contentsOf: storeURL) else {
            return completion(.empty )
        }
        
        let decoder = JSONDecoder()
        let cache = try! decoder.decode(Cache.self, from: data)
        completion(.found(feed: cache.localFeed, timestamp: cache.timestamp))
    }
    
    func insert(_ feed: [LocalFeedImage], timestamp : Date, completion : @escaping FeedStore.InsertionCompletion) {
        
        let encoder = JSONEncoder()
        let cache = Cache(feed: feed.map(CodableFeedImage.init), timestamp: timestamp)
        let encoded = try! encoder.encode(cache)
        try! encoded.write(to: storeURL)
        completion(nil)
    }

}

class CodableFeedStoreTests: XCTestCase {
    
    
    override func setUp() {
        super.setUp()

        try? FileManager.default.removeItem(at: testSpecificStoreURL())
    }
    
    override func tearDown() {
        super.tearDown()
    
        try? FileManager.default.removeItem(at: testSpecificStoreURL())
    }
    
    func test_retrieve_delicersEmptyOnEmptyCache(){
        
        let sut = makeSUT()
        
        let exp = expectation(description: "Wait for retrievel...")
        sut.retrieve() { result in
            switch result {
            case .empty:
                break
                
            default:
                XCTFail("Expected Empty result, got \(result) instead")
            }
            
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }

    
    func test_retrieve_hasNoSideEffectsOnEmptyCache(){
        
        let sut = makeSUT()
        
        let exp = expectation(description: "Wait for retrievel...")
        sut.retrieve { firstResult in
            sut.retrieve { secondResult in

                switch (firstResult,secondResult) {
                case (.empty,.empty):
                        break
                        
                    default:
                        XCTFail("Expected retrieveing twice from empty cache to deliver same empty result, got \(firstResult) and \(secondResult) instead")
                    }
                
                exp.fulfill()
            }
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    
    func test_retrieveAfterInsertingToEMptyCache_deliverInsertedValues(){
        
        let sut = makeSUT()
        let feed = uniqueImageFeed().local
        let timestamp = Date()
        
        let exp = expectation(description: "Wait for retrievel...")
        sut.insert(feed, timestamp: timestamp) { insertionError in
            XCTAssertNil(insertionError,"Expected feed to ne inserted successfully")
                sut.retrieve { retrievedResult in

                    switch retrievedResult {
                        case let .found(retrievedFeed, retrievedTimestamp):
                            XCTAssertEqual(retrievedFeed, feed)
                            XCTAssertEqual(retrievedTimestamp, timestamp)
                        
                        default:
                            XCTFail("Expected found result with feed \(feed) and timestamp \(timestamp), got \(retrievedResult) instead")
                        }
                    
                    exp.fulfill()
            }
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    //MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> CodableFeedStore {
       
        let sut = CodableFeedStore(storeURL: testSpecificStoreURL())
        checkForMemoryLeaks(sut,file: file,line: line)
        return sut
    }
    
    private func testSpecificStoreURL() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("\(type(of:self)).store")
    }
}
