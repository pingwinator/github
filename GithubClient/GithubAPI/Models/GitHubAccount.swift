//
//  GitHubAccount.swift
//  GithubAPI
//
//  Created by Vasyl Liutikov on 06.02.2018.
//  Copyright © 2018 pingwinator. All rights reserved.
//

import Foundation

public struct GitHubAccount: Codable {
    let username: String
    let password: String
    
    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}
