//
//  UserAdapter.swift
//  GithubAPI
//
//  Created by Vasyl Liutikov on 06.02.2018.
//  Copyright © 2018 pingwinator. All rights reserved.
//

import Foundation
import Alamofire

public final class UserAdapter {
    private let account: GitHubAccount
    
    public init(account: GitHubAccount) {
        self.account = account
    }
}

extension UserAdapter: RequestAdapter {
    public func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        
        if let authorizationHeader = Request.authorizationHeader(user: account.username, password: account.password) {
            urlRequest.setValue(authorizationHeader.value, forHTTPHeaderField: authorizationHeader.key)
        }
        
        return urlRequest
    }
}
