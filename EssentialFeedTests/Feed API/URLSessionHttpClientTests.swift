//
//  URLSessionHttpClientTests.swift
//  EssentialFeedTests
//
//  Created by Shreya Pallan on 06/04/21.
//  Copyright © 2021 Shreya Pallan. All rights reserved.
//

import Foundation
import XCTest

class URLSessionHttpCLient {
    private let session : URLSession
    
    init(session : URLSession ){
        self.session = session
    }
    
    func get(from url  : URL){
        session.dataTask(with: url) { (_, _, _) in
            
        }
    }
}

class URLSessionHTTPClientTests : XCTestCase {
    
    func test_get_createsDataTaskWithURL(){
        let url = URL(string: "http://any-url.com")!
        let session = URLSessionSpy()
        let sut = URLSessionHttpCLient(session:session)
        
        sut.get(from : url)
        
        XCTAssertEqual(session.receivedURLs, [url])
    }
}


private class URLSessionSpy : URLSession {
    var receivedURLs = [URL]()
    
    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        receivedURLs.append(url)
        
        return FakeURLSessionDataTask()
    }
    
}

private class FakeURLSessionDataTask : URLSessionDataTask {
    
}

