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
    
    func retrieve(completion : @escaping FeedStore.RetrievalCompletion){
        completion(.empty )
    }
}

class CodableFeedStoreTests: XCTestCase {

    func test_retrieve_delicersEmptyOnEmptyCache(){
        
        let sut = CodableFeedStore()
        
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
        
        let sut = CodableFeedStore()
        
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
}
