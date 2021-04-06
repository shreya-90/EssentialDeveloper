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
    
    func get(from url  : URL, completion : @escaping (HttpClientResult) -> Void){
        session.dataTask(with: url) { (_, _, error) in
            if let error = error {
                completion(.failure(error))
            }
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
       
        sut.get(from : url) { _ in
            
        }
       
        XCTAssertEqual(task.resumeCallCount,1)
    }
    
    
    func test_getFromURL_failsOnRequestError(){
            let url = URL(string: "http://any-url.com")!
            let error = NSError(domain: "test", code: 1)
            let session = URLSessionSpy()
            session.stub(url: url,error: error)
        
            let sut = URLSessionHttpCLient(session:session)
        
            let exp = expectation(description: "Wait for completion")
            sut.get(from: url) { result in
                switch result {
               
                case let .failure(receivedError as NSError):
                    XCTAssertEqual(receivedError,error )
                default:
                    XCTFail("Expected failure with \(error) got \(result) instead")
            }
                exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
}

// MARK :- Helper Methods

private class URLSessionSpy : URLSession {
    var receivedURLs = [URL]()
    
    private var stubs = [URL:Stub]()
    
    private struct Stub {
        let task : URLSessionDataTask
        let error :  Error?
    }
    
    func stub(url : URL , task : URLSessionDataTask = FakeURLSessionDataTask(), error : Error? = nil){
        stubs[url] = Stub(task: task, error: error)
    }
    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        receivedURLs.append(url)
        
        //check if we have a datatask
        guard let stub = stubs[url] else {
            fatalError("Couldn't find stub for \(url)")
        }
        completionHandler(nil,nil, stub.error)
        return stub.task
    
    }
    
}

private class FakeURLSessionDataTask : URLSessionDataTask {}
private class URLSessionDataTaskSpy : URLSessionDataTask {
    var resumeCallCount : Int = 0
       
       override func resume() {
           resumeCallCount += 1
       }
}

