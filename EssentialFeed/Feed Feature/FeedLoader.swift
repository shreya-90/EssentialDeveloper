//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Shreya Pallan on 11/03/21.
//  Copyright © 2021 Shreya Pallan. All rights reserved.
//

import Foundation

public protocol FeedLoader {
    typealias Result = Swift.Result<[FeedImage],Error>
    func load(completion: @escaping (Result ) -> Void)
}
