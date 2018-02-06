//
//  API+User.swift
//  GithubAPI
//
//  Created by Vasyl Liutikov on 06.02.2018.
//  Copyright © 2018 pingwinator. All rights reserved.
//

import Foundation
extension GitHubApi {
    
    public func createUserProvider() -> UserProvider {
        return UserProvider(self)
    }
}
