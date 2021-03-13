//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Shreya Pallan on 11/03/21.
//  Copyright © 2021 Shreya Pallan. All rights reserved.
//

import Foundation
import XCTest
import EssentialFeed   //internal types are not visible unless we use @testable which makes them visible to the test target

class RemoteFeedLoaderTests :  XCTestCase {
    //input is a URL that we don't have yet. To request data from a URL we will need a colaborator. URLSession, AFNetwork.... to actually make the request for us. an HTTPCLient. So the test is that when we (client) call load we will make an HTTP request with that HttpCLient.
    
    func test_init_doesNotRequestDataFromURL() {
        let url = URL(string: "https://a-url.com")!
       
       
       let (_,client) = makeSUT()
        
        
        //sut.load()  //execute load command
        
        XCTAssertTrue(client.requestedURLs.isEmpty)  // we didnt make a load request so url should be nil
    }
    
    
    func test_load_rwquestDataFromURL(){
        
        let url = URL(string: "https://a-given-url.com")!
        //Arrange -  Given a client and sut
        //let client = HTTPClientSpy()
        
        let (sut,client) = makeSUT(url : url)
        
        //Act -  When we invoke load
        sut.load()
        
        //Assert - assert that a url request was initiated in the client
       // XCTAssertNotNil(client.requestedURL)
        XCTAssertEqual(client.requestedURLs,[url])
        
    }
    
    func test_loadTwice_rwquestDataFromURLTwice(){
        
        let url = URL(string: "https://a-given-url.com")!
        //Arrange -  Given a client and sut
        //let client = HTTPClientSpy()
        
        let (sut,client) = makeSUT(url : url)
        
        //Act -  When we invoke load
        sut.load()
        //sut.load()
        
        //Assert - assert that a url request was initiated in the client
       // XCTAssertNotNil(client.requestedURL)
        XCTAssertEqual(client.requestedURLs,[url])
        
    }
    
    
    func test_load_deliversErrorOnClientError() {
        
        let (sut,client) = makeSUT()
         //client.error = NSError(domain: "Test", code: 0)
        
        var capturedErrors = [RemoteFeedLoader.Error]()
        sut.load {
            capturedErrors.append($0)
            
        }
        
        let clientError = NSError(domain: "Testing", code: 0)
        client.completions[0](clientError)
        
        XCTAssertEqual(capturedErrors, [RemoteFeedLoader.Error.connectivity])
        
    }
    
    //MARK: - HELPERS
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!)  -> (sut : RemoteFeedLoader, client : HTTPClientSpy)
    {
        
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url : url , client : client)
        return (sut,client)
        
    }
    
    private class HTTPClientSpy : HTTPClient {
        
        
        //var requestedURL : URL?
        var requestedURLs = [URL]()
       
        var completions = [(Error) -> Void]()
       
        func get(from url: URL, completion: @escaping (Error) -> Void)
        {
            completions.append(completion)
            requestedURLs.append(url)
        }
        
    }
}
