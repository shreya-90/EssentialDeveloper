//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Shreya Pallan on 11/03/21.
//  Copyright © 2021 Shreya Pallan. All rights reserved.
//

import Foundation

public enum LoadFeedResult<Error: Swift.Error> {
    case success([FeedItem])
    case failure(Error)   //Swift Error type
}

//extension LoadFeedResult: Equatable where Error: Equatable {}

protocol FeedLoader {
    
    associatedtype Error : Swift.Error
    func load(completion: @escaping (LoadFeedResult<Error>) -> Void)
}
