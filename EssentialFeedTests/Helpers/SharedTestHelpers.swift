//
//  SharedTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Shreya Pallan on 13/05/21.
//  Copyright © 2021 Shreya Pallan. All rights reserved.
//

import Foundation


func anyNSError() -> NSError {
    return NSError(domain: "any Error", code: 0)
}

func anyURL() -> URL {
    return  URL(string: "http://any-url.com")!
}
