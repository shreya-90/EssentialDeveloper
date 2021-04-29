//
//  XCTestCase+MemoryLeakTracking.swift
//  EssentialFeedTests
//
//  Created by Shreya Pallan on 13/04/21.
//  Copyright © 2021 Shreya Pallan. All rights reserved.
//

import XCTest

extension XCTestCase {
     func checkForMemoryLeaks(_ instance:AnyObject,file: StaticString = #file, line: UInt = #line)
       {
             addTeardownBlock { [weak instance] in
               XCTAssertNil(instance,"Instance should have been deallocated. Potential memory leak.",file: file, line: line)
           }
       }
}
