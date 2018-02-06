//
//  SearchUsersProvider.swift
//  GithubAPI
//
//  Created by Vasyl Liutikov on 06.02.2018.
//  Copyright © 2018 pingwinator. All rights reserved.
//

import Alamofire
import Foundation
import WebLinking

public typealias UserOverviewResponse = (CollectionResponse<UserOverview>?, _ success: Bool, _ error: VLError?) -> Void

public final class SearchUsersProvider {
    public private(set) var users: [UserOverview] = []
    fileprivate let api: GitHubApi
    fileprivate var next: Link?
    public var canLoadNextPage: Bool {
        return next != nil
    }
    
    init(_ api: GitHubApi) {
        self.api = api
    }
    
    @discardableResult
    public func search(query: Set<SearchTerms>, page: UInt = 0, perPage: UInt = 10, onCompletion: @escaping UserOverviewResponse) -> URLRequestConvertible {
        let queryArray = query.map { $0.rawValue }
        let queryString = queryArray.joined(separator: " ")
        let request = Router.search(query: queryString, page: page, perPage: perPage, baseURLString: api.baseURLString)
        return users(request: request, onCompletion: onCompletion)
    }
    
    @discardableResult
    public func loadNextPage(_ onCompletion: @escaping UserOverviewResponse) -> URLRequestConvertible? {
        guard let request = self.next else {
            onCompletion(nil, false, VLError.badRequest)
            return nil
        }
        return users(request: request, prevLoadedUsers:users, onCompletion: onCompletion)
    }
    
    fileprivate func users(request: URLRequestConvertible, prevLoadedUsers:[UserOverview] = [], onCompletion: @escaping UserOverviewResponse) -> URLRequestConvertible {
        api.operationWith(request: request) { json, success, links, error in
            let mapper: ModelResponseSerializer<CollectionResponse<UserOverview>> = ModelResponseSerializer()
            mapper.handleCompletionHandler(data: json, success, error, postMappingAction: { [weak self] (response) -> CollectionResponse<UserOverview> in
                self?.users = prevLoadedUsers + response.data
                self?.next = links.findNext()
                return response
                }, onCompletion)
        }
        
        return request
    }
    
}

extension SearchUsersProvider {
    enum Router: URLRequestConvertible {
        case search(query: String, page: UInt, perPage: UInt, baseURLString: String)
        
        // MARK: URLRequestConvertible
        
        func asURLRequest() throws -> URLRequest {
            let result: (baseURLString: String, path: String, parameters: Parameters) = {
                switch self {
                case let .search(query, page, perPage, baseURLString) where page > 0:
                    return (baseURLString, "/users", ["q": query, "per_page": perPage, "page": page])
                case let .search(query, _, perPage, baseURLString):
                    return (baseURLString, "/users", ["q": query, "per_page": perPage])
                }
            }()
            
            let url = try result.baseURLString.asURL()
            let urlRequest = URLRequest(url: url.appendingPathComponent(result.path))
            
            return try URLEncoding.default.encode(urlRequest, with: result.parameters)
        }
    }
}
