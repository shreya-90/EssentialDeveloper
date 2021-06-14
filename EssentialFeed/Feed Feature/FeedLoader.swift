//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Shreya Pallan on 11/03/21.
//  Copyright © 2021 Shreya Pallan. All rights reserved.
//

import Foundation

//public enum LoadFeedResult {
//    case success([FeedImage])
//    case failure(Error)   //Swift Error type
//}

public typealias LoadFeedResult = Result<[FeedImage],Error>

public protocol FeedLoader {
    
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
