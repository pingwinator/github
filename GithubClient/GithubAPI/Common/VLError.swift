//
//  VLError.swift
//  GithubAPI
//
//  Created by Vasyl Liutikov on 06.02.2018.
//  Copyright © 2018 pingwinator. All rights reserved.
//

import Foundation
public enum VLError: Error, CustomStringConvertible, CustomDebugStringConvertible {
    /// can't create model
    case mapping(String)
    /// host not reachable
    case noInternet
    ///
    case badRequest
    /// network error (AFNetworking, etc)
    case network(APIError<GithubError>)
    
    public var description: String {
        switch self {
            
        case .mapping:
            return "Something wrong"
        case .noInternet:
            return "No internet connection"
        case .network(let error):
            if let errorModel = error.errorModel {
                return errorModel.message
            }
            return "Something wrong"
        case .badRequest:
            return "Can't load"
        }
    }
    
    public var debugDescription: String {
        switch self {
            
        case .mapping(let objectName):
            return "object mapping error: \(objectName)"
        case .noInternet:
            return "internet.connection.unavailable"
        case .badRequest:
            return "cant.load"
        case .network(let error):
            if let errorModel = error.errorModel {
                return errorModel.message
            }
            return error.localizedDescription
        }
    }
}

extension VLError {
    var isNoInternet: Bool {
        switch self {
        case .noInternet:
            return true
        case .network(let apiError):
            if let networkError = apiError.error as NSError?, (networkError.code == NSURLErrorTimedOut || networkError.code == NSURLErrorNotConnectedToInternet) {
                return true
            } else {
                return false
            }
        default:
            return false
        }
    }
}
