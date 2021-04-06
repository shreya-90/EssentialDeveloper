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
            
        }.resume()
    }
}

class URLSessionHTTPClientTests : XCTestCase {
    
//    func test_get_createsDataTaskWithURL(){
//        let url = URL(string: "http://any-url.com")!
//        let session = URLSessionSpy()
//        let sut = URLSessionHttpCLient(session:session)
//        
//        sut.get(from : url)
//        
//        XCTAssertEqual(session.receivedURLs, [url])
//    }
    
    func test_get_resumesDataTask(){
        
       let url = URL(string: "http://any-url.com")!
       let session = URLSessionSpy()
       let task = URLSessionDataTaskSpy()
        
        //You need to tell this session to return THIS DataTaskSpy for a particular URL -  stub that behavious
       session.stub(url: url, task:task)
       let sut = URLSessionHttpCLient(session:session)
       
       sut.get(from : url)
       
        XCTAssertEqual(task.resumeCallCount,1)
    }
}

// MARK :- Helper Methods

private class URLSessionSpy : URLSession {
    var receivedURLs = [URL]()
    
    private var stubs = [URL:URLSessionDataTask]()
    
    func stub(url : URL , task : URLSessionDataTask){
        stubs[url] = task
    }
    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        receivedURLs.append(url)
        
        return stubs[url] ?? FakeURLSessionDataTask()
    }
    
}

private class FakeURLSessionDataTask : URLSessionDataTask {}
private class URLSessionDataTaskSpy : URLSessionDataTask {
    var resumeCallCount : Int = 0
       
       override func resume() {
           resumeCallCount += 1
       }
}

