//
//  WebLinksHelper.swift
//  GithubAPI
//
//  Created by Vasyl Liutikov on 06.02.2018.
//  Copyright © 2018 pingwinator. All rights reserved.
//

import Alamofire
import Foundation
import WebLinking

extension Link: URLRequestConvertible {
    
    public func asURLRequest() throws -> URLRequest {
        let url = try self.uri.asURL()
        return URLRequest(url:url)
        
    }
}

extension Sequence where Iterator.Element == Link {
    /// Finds a link which has matching parameters
    func findLink(_ parameters: [String: String]) -> Link? {
        for link in self where link.parameters ~= parameters {
            return link
        }
        
        return nil
    }
    
    /// Find a link for the relation
    func findLink(relation: String) -> Link? {
        return self.findLink(["rel": relation])
    }
    
    func findNext() -> Link? {
        return self.findLink(relation: "next")
    }
}

//this function copied from WebLinking pod
/// LHS contains all the keys and values from RHS
func ~= (lhs: [String: String], rhs: [String: String]) -> Bool {
    
    for (key, value) in rhs where lhs[key] != value {
        return false
    }
    return true
}
