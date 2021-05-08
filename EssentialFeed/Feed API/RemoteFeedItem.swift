//
//  RemoteFeedImage.swift
//  EssentialFeed
//
//  Created by Shreya Pallan on 08/05/21.
//  Copyright © 2021 Shreya Pallan. All rights reserved.
//

import Foundation

internal struct RemoteFeedImage : Decodable {
    
     internal let id : UUID
     internal let description : String?
     internal let location : String?
     internal let image : URL
}
