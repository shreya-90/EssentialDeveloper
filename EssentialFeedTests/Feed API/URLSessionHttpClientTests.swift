//
//  URLSessionHttpClientTests.swift
//  EssentialFeedTests
//
//  Created by Shreya Pallan on 06/04/21.
//  Copyright © 2021 Shreya Pallan. All rights reserved.
//

import Foundation
import XCTest

//protocol HttpSession {
//    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> HTTPSessionTask
//}
//
//protocol HTTPSessionTask {
//    func resume()
//}

class URLSessionHttpCLient {
    private let session : URLSession
    
    init(session : URLSession = .shared){
        self.session = session
    }
    
    func get(from url  : URL, completion : @escaping (HttpClientResult) -> Void){
//        let url = URL(string: "http://wrong-url.com")!
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
        
    override class func setUp() {    /* setup and teardown are run for each test case */
        
        super.setUp()
        URLProtocolStub.startInterceptingRequests()
    }
    
    override func tearDown() {
        
        super.tearDown()
        URLProtocolStub.stopInterceptingRequests()
    }
    
    func test_getFromURL_failsOnRequestError(){
        
        URLProtocolStub.startInterceptingRequests()
            let url = URL(string: "http://any-url.com")!
            let error = NSError(domain: "test", code: 1)
//            let session = HTTPSessionSpy()
        
        //still need to stub the url with an error
        URLProtocolStub.stub(data:nil,response:nil,error: error)
                
            let exp = expectation(description: "Wait for completion")
            makeSUT().get(from: url) { result in
                switch result {
               
                case let .failure(receivedError as NSError):
                    XCTAssertEqual(receivedError,error )
                default:
                    XCTFail("Expected failure with \(error) got \(result) instead")
            }
                exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        URLProtocolStub.stopInterceptingRequests()
    }
    
    
    func test_getFromURL_performsGETRequestsWithURL(){
        URLProtocolStub.startInterceptingRequests()
        
        let url = URL(string: "http://any-url.com")!
        let exp = expectation(description: "wait for request to complete...")
        URLProtocolStub.observeRequests { request in
            XCTAssertEqual(request.url, url)
            XCTAssertEqual(request.httpMethod, "GET")
            
            exp.fulfill()
        }
        
        makeSUT().get(from: url) { _ in }
        
        wait(for: [exp], timeout: 1.0)
        
        URLProtocolStub.stopInterceptingRequests()
    }
}

// MARK :- Helper Methods

private func makeSUT() -> URLSessionHttpCLient {
    return URLSessionHttpCLient()
}

private class URLProtocolStub : URLProtocol {
    
    private static var stubs : Stub?
    private static var requestObserver : ((URLRequest) -> Void)?   //Capture the closure
    
    private struct Stub {
        let data : Data?
        let response : URLResponse?
        let error :  Error?
    }
    
    static func  stub( data: Data?, response : URLResponse?, error : Error? = nil){
        stubs = Stub( data: data, response:response, error: error)
    }
    
    static func observeRequests(observer : @escaping (URLRequest) -> Void) {
        requestObserver = observer
    }
    
    static func startInterceptingRequests(){
        URLProtocol.registerClass(URLProtocolStub.self)
    }
    
    static func stopInterceptingRequests(){
        URLProtocol.unregisterClass(URLProtocolStub.self)
        stubs = nil
        requestObserver = nil
    }
    
    override class func canInit(with request: URLRequest) -> Bool {    // CLASS method. So we don't have an instance yet
//        guard let url =  request.url else { return false }
//
//        return URLProtocolStub.stubs[url] != nil
        requestObserver?(request)
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let url = request.url, let stub =  URLProtocolStub.stubs else { return }
        
        if let data = stub.data {
            client?.urlProtocol(self, didLoad: data)
        }
        
        if let response = stub.response {
            client?.urlProtocol(self, didReceive: response,cacheStoragePolicy: .notAllowed)
        }
        if let error = stub.error {
            client?.urlProtocol(self, didFailWithError: error)
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        
    }
}


