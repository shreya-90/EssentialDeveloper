//
//  CodableFeedStoreTests.swift
//  EssentialFeedTests
//
//  Created by Shreya Pallan on 16/05/21.
//  Copyright © 2021 Shreya Pallan. All rights reserved.
//

import XCTest
import EssentialFeed



class CodableFeedStoreTests: XCTestCase,FailableFeedStore {
    
    
    override func setUp() {
        super.setUp()
        setupEmptyStoreState()
    }
    
    override func tearDown() {
        super.tearDown()
        undoStoreSideEffects()
    }
    
    func test_retrieve_deliversEmptyOnEmptyCache(){
        
        let sut = makeSUT()
        
        assertThatRetrieveDeliversEmptyOnEmptyCache(on: sut)
    }

    
    func test_retrieve_hasNoSideEffectsOnEmptyCache(){
        
        let sut = makeSUT()
        
        assertThatRetrieveHasNoSideEffectsOnEmptyCache(on: sut)
    }
    
    
    func test_retrieve_deliversFoundValuesAfterInsertingToEmptyCache(){
        
        let sut = makeSUT()
       
        assertThatRetrieveDeliversFoundValuesOnNonEmptyCache(on: sut)
    }
    
    
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache(){
        
        let sut = makeSUT()
       
        assertThatRetrieveHasNoSideEffectsOnNonEmptyCache(on: sut)
        
    }
    
    func test_retrieve_deliversFailureOnRetrievalError(){
        let storeURL = testSpecificStoreURL()
        let sut = makeSUT(storeURL: storeURL)
        
        try! "invalid data".write(to: storeURL, atomically: false, encoding: .utf8)
        assertThatRetrieveDeliversFailureOnRetrievalError(on: sut)
    }
    
    func test_retrieve_hasNoSideEffectsOnFailure(){
        let storeURL = testSpecificStoreURL()
        let sut = makeSUT(storeURL: storeURL)
        
        try! "invalid data".write(to: storeURL, atomically: false, encoding: .utf8)
        
        assertThatRetrieveHasNoSideEffectsOnFailure(on: sut)
    }
    
    func test_insert_deliversNoErrorOnEmptyCache(){
        let sut = makeSUT()
        
        assertThatInsertDeliversNoErrorOnEmptyCache(on: sut)
    }
    
    func test_insert_deliversNoErrorOnNonEmptyCache(){
        let sut = makeSUT()
           
        assertThatInsertDeliversNoErrorOnNonEmptyCache(on: sut)
    }
    
    func test_insert_overridePreviouslyInsertedCacheValues(){
        let sut = makeSUT()
          
        assertThatInsertOverridesPreviouslyInsertedCacheValues(on: sut)
    }
    
    func test_insert_deliversErrorOnInsertionError(){
        let invalidStoreURL = URL(string: "invalid://store-url")
        let sut = makeSUT(storeURL: invalidStoreURL)
        
        let insertionError = insert(( uniqueImageFeed().local,  Date()), to: sut)
        XCTAssertNotNil(insertionError,"Expected cache insertion to fail with error")
        

    }
    
    func test_insert_hasNosideEffectsOnInsertionError(){
        let invalidStoreURL = URL(string: "invalid://store-url")
        let sut = makeSUT(storeURL: invalidStoreURL)
        let feed = uniqueImageFeed().local
        let timestamp = Date()
        
        insert((feed, timestamp), to: sut)
        expect(sut, toRetrieveTwice: .empty)

    }
    
    func test_delete_deliversNoErrorOnEmptyCache(){
        let sut = makeSUT()
        assertThatDeleteDeliversNoErrorOnEmptyCache(on: sut)
    }
    
    func test_delete_hasNoSideEffectsOnEmptyCache(){
           let sut = makeSUT()
           assertThatDeleteHasNoSideEffectsOnEmptyCache(on: sut)
    }
           
    func test_delete_deliversNoErrorOnNonEmptyCache(){
        let sut = makeSUT()
        assertThatDeleteDeliversNoErrorOnNonEmptyCache(on: sut)
    }
    
    func test_delete_emptiesPreviouslyInsertedCache(){
        let sut = makeSUT()
        assertThatDeleteEmptiesPreviouslyInsertedCache(on: sut)
    }
    
    func test_delete_deliversErrorOnDeletionError() {
        let noDeletePermissionURL = cachesDirectory()
        let sut = makeSUT(storeURL: noDeletePermissionURL)
        
        let deletionError = deleteCache(from: sut)
        
        XCTAssertNotNil(deletionError,"Expected cache deletion to fail  ")
    }
    func test_delete_hasNoSideEffectsOnDeletionError() {
        let noDeletePermissionURL = cachesDirectory()
        let sut = makeSUT(storeURL: noDeletePermissionURL)
        
        deleteCache(from: sut)
        
        expect(sut, toRetrieve: .empty)
    }
    
    func test_storeSideEffects_runSerially(){
        let sut = makeSUT()
        assertThatSideEffectsRunSerially(on: sut)
        
    }
    //MARK: - Helpers
    
    private func makeSUT(storeURL: URL? = nil,file: StaticString = #file, line: UInt = #line) -> FeedStore {
          
               let sut = CodableFeedStore(storeURL: storeURL ?? testSpecificStoreURL())
               checkForMemoryLeaks(sut,file: file,line: line)
               return sut
    }
    
    private func testSpecificStoreURL() -> URL {
            return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("\(type(of:self)).store")
    }
    
    private func undoStoreSideEffects(){
            deleteStoreArtifacts()
    }
    private func setupEmptyStoreState() {
            deleteStoreArtifacts()
    }
    private func deleteStoreArtifacts(){
            try? FileManager.default.removeItem(at: testSpecificStoreURL())
    }
    private func cachesDirectory() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
}
