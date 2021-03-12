//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Shreya Pallan on 11/03/21.
//  Copyright © 2021 Shreya Pallan. All rights reserved.
//

import Foundation

import XCTest
class RemoteFeedLoader {
    func load() {
        HTTPClient.shared.requestedURL = URL(string: "https://a-url.com")
    }
}

class HTTPClient {
   static let shared = HTTPClient()
    
    private init() {}
    var requestedURL : URL?
}

class RemoteFeedLoaderTests :  XCTestCase {
    //input is a URL that we don't have yet. To request data from a URL we will need a colaborator. URLSession, AFNetwork.... to actually make the request for us. an HTTPCLient. So the test is that when we (client) call load we will make an HTTP request with that HttpCLient.
    
    func test_init_doesNotRequestDataFromURL() {
        
        let client = HTTPClient.shared
        //system under test is the remote feed loader
        _ = RemoteFeedLoader()
        
        
        //sut.load()  //execute load command
        
        XCTAssertNil(client.requestedURL)  // we didnt make a load request so url should be nil
    }
    
    
    func test_load_rwquestDataFromURL(){
        
        
        //Arrange -  Given a client and sut
        let client = HTTPClient.shared
        let sut = RemoteFeedLoader()
        
        //Act -  When we invoke load
        sut.load()
        
        //Assert - assert that a url request was initiated in the client
        XCTAssertNotNil(client.requestedURL)
        
        
        //But why does HttpClient need to be a singleton... there needs to be a good reason
    }
}
