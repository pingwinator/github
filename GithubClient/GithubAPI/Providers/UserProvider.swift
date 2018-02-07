//
//  UserProvider.swift
//  GithubAPI
//
//  Created by Vasyl Liutikov on 06.02.2018.
//  Copyright © 2018 pingwinator. All rights reserved.
//

import Alamofire
import Cache
import Foundation
import WebLinking

public typealias UserResponse = (User?, _ success: Bool, _ error: VLError?) -> Void

public final class UserProvider {
    fileprivate let api: GitHubApi
    fileprivate let cacheTtl: Expiry = .seconds(30 * 24 * 60 * 60) // ~30 days
    
    fileprivate var users: [URL: User] = [:]
    init(_ api: GitHubApi) {
        self.api = api
    }
    
    public func prefetchUser(users: [UserOverview]) {
        let notLoadedUsers = users.filter { (user) -> Bool in
            if let url = user.urlRequest?.url?.absoluteString,
                let cache = self.api.cache,
                let exist = try? cache.existsObject(ofType: User.self, forKey: url),
                exist {
                return false
            } else {
                return true
            }
        }
        if notLoadedUsers.count > 0 {
            for user in notLoadedUsers {
                loadDetails(for: user) { _, _, _ in }
            }
        }
    }
    
    @discardableResult
    public func loadDetails(for user: UserOverview, allowCache: Bool = true, onCompletion: @escaping UserResponse) -> URLRequestConvertible {
        return userDetails(request: user, allowCache: allowCache, onCompletion: onCompletion)
    }
    
    @discardableResult
    func userDetails(request: URLRequestConvertible, allowCache: Bool = true, onCompletion: @escaping UserResponse) -> URLRequestConvertible {
        if allowCache,
            let url = request.urlRequest?.url?.absoluteString,
            let cache = self.api.cache,
            let user = try? cache.object(ofType: User.self, forKey: url) {
            onCompletion(user, true, nil)
            return request
        }
        api.operationWith(request: request) { json, success, _, error in
            let mapper: ModelResponseSerializer<User> = ModelResponseSerializer()
            mapper.handleCompletionHandler(data: json, success, error, postMappingAction: { [weak self] (response) -> User in
                if let url = request.urlRequest?.url {
                    self?.users[url] = response
                    if let key = request.urlRequest?.url?.absoluteString, let cache = self?.api.cache {
                        try? cache.setObject(response, forKey: key, expiry: self?.cacheTtl)
                    }
                }
                return response
            }, onCompletion)
        }
        
        return request
    }
    
}
