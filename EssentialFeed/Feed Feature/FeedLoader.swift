//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Shreya Pallan on 11/03/21.
//  Copyright © 2021 Shreya Pallan. All rights reserved.
//

import Foundation

enum LoadFeedResult {
    case Success([FeedItem])
    case error(Error)
}
protocol FeedLoader {
    
    func load(completion : @escaping ([FeedItem])-> Void)
}
