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
    
    let client : HTTPClient
    
    init(client:  HTTPClient) {
        self.client = client
    }
    
    func load() {
       // HTTPClient.shared.get(from: URL(string: "https://a-url.com")!)   // locating the client & calling a function => violating SRP
        
       client.get(from: URL(string: "https://a-url.com")!)  //problem solved
        
    }
}

protocol HTTPClient {   // this is currently an abstract class and swift provides a better way of defining these                   interfaces - protocols

   func get(from url: URL)
}

class HTTPClientSpy : HTTPClient {
    var requestedURL : URL?
    
    func get(from url: URL) {
        self.requestedURL = url
    }
    
}

class RemoteFeedLoaderTests :  XCTestCase {
    //input is a URL that we don't have yet. To request data from a URL we will need a colaborator. URLSession, AFNetwork.... to actually make the request for us. an HTTPCLient. So the test is that when we (client) call load we will make an HTTP request with that HttpCLient.
    
    func test_init_doesNotRequestDataFromURL() {
        
        let client = HTTPClientSpy()
       
        _ = RemoteFeedLoader(client:client)
        
        
        //sut.load()  //execute load command
        
        XCTAssertNil(client.requestedURL)  // we didnt make a load request so url should be nil
    }
    
    
    func test_load_rwquestDataFromURL(){
        
        
        //Arrange -  Given a client and sut
        let client = HTTPClientSpy()
        
        let sut = RemoteFeedLoader(client:client)
        
        //Act -  When we invoke load
        sut.load()
        
        //Assert - assert that a url request was initiated in the client
        XCTAssertNotNil(client.requestedURL)
        
    }
}
