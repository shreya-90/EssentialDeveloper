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

class URLSessionHttpCLient : HTTPClient {
    private let session : URLSession
    
    init(session : URLSession = .shared){
        self.session = session
    }
    
    struct UnexpectedValueRepresentation : Error {}
    
    func get(from url  : URL, completion : @escaping (HttpClientResult) -> Void){
//        let url = URL(string: "http://wrong-url.com")!
        session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }else if let data = data, let response = response as? HTTPURLResponse {
                completion(.success(data, response))
            } else {
                completion(.failure(UnexpectedValueRepresentation()))
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
//        URLProtocolStub.startInterceptingRequests()
    }
    
    override func tearDown() {
        
        super.tearDown()
//        URLProtocolStub.stopInterceptingRequests()
    }
    /* checks if we stubbed with error then we get back error*/
    func test_getFromURL_failsOnRequestError(){
        
        URLProtocolStub.startInterceptingRequests()
        let requestError = anyNSError()

        let receivedError = resultErrorFor(data: nil, response:nil,error: requestError )
            
        XCTAssertEqual(receivedError as NSError?,requestError as NSError?)
                
        URLProtocolStub.stopInterceptingRequests()
    }
    
    /* Checks for Invalid states (table)*/
        func test_getFromURL_failsOnAllInvalidRepresentationCases(){
            
            URLProtocolStub.startInterceptingRequests()
            
            
            
            XCTAssertNotNil(resultErrorFor(data: nil, response: nil,error: nil))
            XCTAssertNotNil(resultErrorFor(data: nil, response: nonHTTPURLResponse(),error: nil))
            XCTAssertNotNil(resultErrorFor(data: anyData(), response: nil,error: nil))
            XCTAssertNotNil(resultErrorFor(data: anyData(), response: nil,error: anyNSError()))
            XCTAssertNotNil(resultErrorFor(data: nil, response: nonHTTPURLResponse(),error: anyNSError()))
            XCTAssertNotNil(resultErrorFor(data: nil, response: anyHTTPURLResponse(),error: anyNSError()))
            XCTAssertNotNil(resultErrorFor(data: anyData(), response: nonHTTPURLResponse(),error: anyNSError()))
            XCTAssertNotNil(resultErrorFor(data: anyData(), response: anyHTTPURLResponse(),error: anyNSError()))
            XCTAssertNotNil(resultErrorFor(data: anyData(), response: nonHTTPURLResponse(),error: nil))





            URLProtocolStub.stopInterceptingRequests()
        }
    
    func test_getFromURL_succeedsOnHTTPURLResponseWithData() {
        
        URLProtocolStub.startInterceptingRequests()
         let data = anyData()
         let response = anyHTTPURLResponse()
        
         let receivedValues = resultValuesFor(data: data, response: response, error : nil)
                   
                  
        XCTAssertEqual(receivedValues?.data, data)
        XCTAssertEqual(receivedValues?.response.url, response.url)
        XCTAssertEqual(receivedValues?.response.statusCode, response.statusCode)
        
       
        URLProtocolStub.stopInterceptingRequests()
    }
    
    /* Our assumption abput the framework got validated here **/
    /*in the nil, response,nil case - URL loading system is replcing nil data with Empty data leading to success instead of failure ( invalid case )**/
    
        func test_getFromURL_succeedsWithEmptyDataOnHTTPURLResponseWithNilData() {
            
            URLProtocolStub.startInterceptingRequests()
           
            let response = anyHTTPURLResponse()
            
            let receivedValues = resultValuesFor(data: nil, response: response, error : nil)
            
            let emptyData = Data()
            XCTAssertEqual(receivedValues?.data,emptyData)
            XCTAssertEqual(receivedValues?.response.url, response.url)
            XCTAssertEqual(receivedValues?.response.statusCode, response.statusCode)


             
            URLProtocolStub.stopInterceptingRequests()
        }
    
    /* checks the URL comparison and other request parameters (body, query paramaters )*/
    func test_getFromURL_performsGETRequestsWithURL(){
        URLProtocolStub.startInterceptingRequests()
        
        let url = anyURL()
        let exp = expectation(description: "wait for request to complete...")
        URLProtocolStub.observeRequests { request in
            XCTAssertEqual(request.url, url)
            XCTAssertEqual(request.httpMethod, "GET")
            
            exp.fulfill()
        }
        
        makeSUT().get(from: anyURL()) { _ in }
        
        wait(for: [exp], timeout: 1.0)
        
        URLProtocolStub.stopInterceptingRequests()
    }
    
    //MARK:- Helper Methods
    
    /* factory method for sut */
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> HTTPClient {
        let sut =  URLSessionHttpCLient()
        checkForMemoryLeaks(sut, file: file,line:line)
        return sut
    }

    private func anyURL() -> URL {
            return  URL(string: "http://any-url.com")!
    }
    
    private func anyData() -> Data {
        return Data(bytes: "any data".utf8)
    }
    
    private func anyNSError() -> Error {
        return NSError(domain: "any Error", code: 0)
    }
    
    private func anyHTTPURLResponse() -> HTTPURLResponse {
        return HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!
    }
    
    private func nonHTTPURLResponse() -> URLResponse {
        return URLResponse(url: anyURL(), mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
    }
    
    private func resultErrorFor(data: Data?, response : URLResponse?, error : Error? = nil , file: StaticString = #file, line: UInt = #line) -> Error?
    {
        
        let result = resultFor(data: data, response: response,error: error, file: file,line: line)
        
                switch result {
                    
                case let .failure(error):
                   return error
                default:
                    XCTFail("Expected failure, got \(result) instead",file:file,line: line)
                    return nil
            }
                
        
    }
    
    
    private func resultValuesFor(data: Data?, response : URLResponse?, error : Error? = nil , file: StaticString = #file, line: UInt = #line) -> (data : Data, response : HTTPURLResponse)?
    {
        let result = resultFor(data: data, response: response,error: error, file: file,line: line)
    
                switch result {
                    
                case let .success(receivedData, receivedResponse):
                   return (receivedData,receivedResponse)
                default:
                    XCTFail("Expected success, got \(result) instead",file:file,line: line)
                    return nil
            }
               
    }
    
    
    private func resultFor(data: Data?, response : URLResponse?, error : Error? = nil , file: StaticString = #file, line: UInt = #line) -> HttpClientResult {
        
        URLProtocolStub.stub(data:data,response:response,error: error)
        
        let sut = makeSUT(file:file,line: line)
        let exp = expectation(description: "Wait for completion")
        
            var receivedResult : HttpClientResult!
            sut.get(from: anyURL()) { result in
               
                receivedResult = result
                exp.fulfill()
            }
            
            wait(for: [exp], timeout: 1.0)
            return receivedResult
        
    }
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
        
        /* we pass the data forward to the  URL loading system by intercepting it here , we tell the URL system to return back - data/response/error accordingly */
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


