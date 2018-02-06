//
//  APIError.swift
//  GithubAPI
//
//  Created by Vasyl Liutikov on 06.02.2018.
//  Copyright © 2018 pingwinator. All rights reserved.
//

import Foundation
public struct APIError<T>: Error {
    
    /// URLRequest that was unsuccessful
    public let request: URLRequest?
    
    /// Response received from web service
    public let response: HTTPURLResponse?
    
    /// Data, contained in response
    public let data: Data?
    
    /// Error instance, created by Foundation Loading System or Alamofire.
    public let error: Error?
    
    /// Parsed Error model
    public var errorModel: T?
    
    /**
     Initialize `APIError` with unsuccessful request info.
     
     - parameter request: URLRequest that was unsuccessful
     
     - parameter response: response received from web service
     
     - parameter data: data, contained in response
     
     - error: Error instance, created by Foundation Loading System or Alamofire.
     */
    public init(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) {
        self.request = request
        self.response = response
        self.data = data
        self.error = error
    }
    
    /**
     Convenience initializer, that can be used to create fixtured `APIError`.
     */
    public init(errorModel: T) {
        self.init(request: nil, response: nil, data: nil, error: nil)
        self.errorModel = errorModel
    }
}
