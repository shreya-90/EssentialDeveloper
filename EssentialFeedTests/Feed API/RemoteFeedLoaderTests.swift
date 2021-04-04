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
        sut.load(completion: { _ in })
        
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
        sut.load(completion: { _ in })
        //sut.load()
        
        //Assert - assert that a url request was initiated in the client
       // XCTAssertNotNil(client.requestedURL)
        XCTAssertEqual(client.requestedURLs,[url])
        
    }
    
    
    func test_load_deliversErrorOnClientError() {
        
        let (sut,client) = makeSUT()
         //client.error = NSError(domain: "Test", code: 0)
        
        
        expect(sut,toCompleteWith: .failure(.connectivity), when : {
            let clientError = NSError(domain: "Testing", code: 0)
            client.complete(with :  clientError)
            
        })
        
       
        
    }
    
    
    func test_load_deliversErrorOnNon200HttpResponse() {
        
        let (sut,client) = makeSUT()
         //client.error = NSError(domain: "Test", code: 0)
        
        
        
        [199,201,300,400].enumerated().forEach { (index,code) in
            
            expect(sut,toCompleteWith: .failure(.invalidData), when : {
                client.complete(withStatusCode :  code ,at: index)
            })
        }
        
        
        
        
    }
    
    func test_load_deliversErrorOn200HttpResponseWithInvalidJSON(){
         let (sut,client) = makeSUT()
    
        expect(sut,toCompleteWith: .failure(.invalidData), when : {
            //let invalidJSON = Data(bytes: "invalid json".utf8)
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode :  200 ,data: invalidJSON)
        })
        
        
    }
    
    //HAppy path tests
    
    func test_load_deliversNoItemsOn200HttpResponseWithEmptyJSONList(){
         let (sut,client) = makeSUT()
        
        expect(sut, toCompleteWith: RemoteFeedLoader.Result.success([]), when: {
            let emptyListJSON = Data(bytes: "{\"items\": []}".utf8)
            client.complete(withStatusCode: 200, data: emptyListJSON)
        })
       
    
    }
    
    func test_load_deliversItemsOn200HttpResponseWithJSONItems(){
            let (sut,client) = makeSUT()
        
            let item1 = makeItem(
            id : UUID(),
            description: nil,
            location: nil,
            imageURL: URL(string: "https://a-url.com")!)
            
            
        
            let item2 = makeItem(
            id : UUID(),
            description: "a description",
            location: "a location",
            imageURL: URL(string: "https://another-url.com")!)
        
           
        
            
            let items = [item1.model,item2.model]
        
            expect(sut, toCompleteWith: .success(items), when: {
            let json = makeItemsJSON(with: [item1.json,item2.json])
            client.complete(withStatusCode: 200, data: json)
            })
        
        
    }
    
    func test_load_doesNotDeliverResultIfTheSUTInstanceHasBeenDeallocated() {
        
        let client = HTTPClientSpy()
        let url = URL(string: "http://any-url.com")!
        var sut: RemoteFeedLoader? = RemoteFeedLoader(url: url, client: client)
        
        var capturedResults = [RemoteFeedLoader.Result]()
        sut?.load { result in
           capturedResults.append(result)
        }
        
        sut = nil
        
        client.complete(withStatusCode: 200, data: makeItemsJSON(with: []), at: 0)
        
        XCTAssertTrue(capturedResults.isEmpty)
    }
    
    //MARK: - HELPERS
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!,file: StaticString = #file, line: UInt = #line)  -> (sut : RemoteFeedLoader, client : HTTPClientSpy)
    {
        
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url : url , client : client)
        checkForMemoryLeaks(sut,file: file,line: line)
        checkForMemoryLeaks(client,file: file,line: line)
        return (sut,client)
        
    }
    
    private func checkForMemoryLeaks(_ instance:AnyObject,file: StaticString = #file, line: UInt = #line){
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance,"Instance should have been deallocated. Potential memory leak.",file: file, line: line)
        }
    }
    
    private func makeItem(id:UUID,description : String?, location : String?, imageURL : URL) -> (model: FeedItem, json : [String:Any])
    {
        let item = FeedItem(id: id, description: description, location: location, imageURL: imageURL)
        
        let json = [
            "id":id.uuidString,
            "description": description,
            "location":location,
            "image":imageURL.absoluteString
            ].reduce(into: [String:Any]()){(acc,e) in
                if let value = e.value {acc[e.key] = value}
        }
        return (item,json)
    }
    
    private func makeItemsJSON(with items : [[String:Any]]) -> Data
    {
        let json = [
            "items":items
        ]
        return try! JSONSerialization.data(withJSONObject: json)

        
    }
    
    private func expect(_ sut: RemoteFeedLoader,toCompleteWith result: RemoteFeedLoader.Result, when action :  () -> Void, file: StaticString = #file, line: UInt = #line){
        
        var capturedResults = [RemoteFeedLoader.Result]()
        sut.load { result in
           capturedResults.append(result)
        }
       
        action()
       
        XCTAssertEqual(capturedResults, [result], file: file, line: line)
    }
    
    private class HTTPClientSpy : HTTPClient {
        
        var requestedURLs : [URL] {
            return messages.map { $0.url }
        }
        
        private var messages = [(url : URL,completion :
            (HttpClientResult) -> Void)]()
       
        func get(from url: URL, completion: @escaping (HttpClientResult) -> Void)
        {
            messages.append((url,completion))
//            completions.append(completion)
//            requestedURLs.append(url)
        }
        
        func complete(with error :  Error, with index : Int = 0){
//            completions[index](error)
            messages[index].completion(.failure(error))
        }
        

        func complete( withStatusCode code :  Int, data : Data = Data(),at index : Int = 0){
             let response = HTTPURLResponse(
                url: requestedURLs[index],
                statusCode: code,
                httpVersion: nil,
                headerFields: nil)!
            messages[index].completion(.success(data,response))
        }
        
        
    }
}
