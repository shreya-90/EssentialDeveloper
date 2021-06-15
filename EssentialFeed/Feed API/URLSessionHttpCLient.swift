//
//  URLSessionHttpCLient.swift
//  EssentialFeed
//
//  Created by Shreya Pallan on 16/04/21.
//  Copyright © 2021 Shreya Pallan. All rights reserved.
//

import Foundation


public class URLSessionHttpCLient : HTTPClient {
    private let session : URLSession
    
    public init(session : URLSession = .shared){
        self.session = session
    }
    
    private struct UnexpectedValueRepresentation : Error {}
    
    public func get(from url  : URL, completion : @escaping (HTTPClient.Result) -> Void){
//        let url = URL(string: "http://wrong-url.com")!
        session.dataTask(with: url) { (data, response, error) in
            completion(Result {
                if let error = error {
                    throw error
                }else if let data = data, let response = response as? HTTPURLResponse {
                    return (data, response)
                } else {
                    throw UnexpectedValueRepresentation()
                }
            })
            
        }.resume()
    }
}
