//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by Shreya Pallan on 11/03/21.
//  Copyright © 2021 Shreya Pallan. All rights reserved.
//

import Foundation



public struct FeedItem: Equatable {
    
    let id : UUID
    let description : String?
    let location : String?
    let imageURL : URL
}
