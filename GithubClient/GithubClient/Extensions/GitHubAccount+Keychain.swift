//
//  GitHubAccount+Keychain.swift
//  GithubClient
//
//  Created by Vasyl Liutikov on 06.02.2018.
//  Copyright © 2018 pingwinator. All rights reserved.
//

import Foundation
import GithubAPI
import Simple_KeychainSwift

extension GitHubAccount: TypeSafeKeychainValue {
    public func data() -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(self)
    }
    
    public static func value(data: Data) -> GitHubAccount? {
        let decoder = JSONDecoder()
        return try? decoder.decode(GitHubAccount.self, from: data)
    }
}

extension GitHubAccount {
    
    static let defaultKey = "gh"
    
    @discardableResult
    func save(key: String = GitHubAccount.defaultKey) -> Bool {
        return Keychain.set(self, forKey: key)
    }
    
    static func read(key: String = GitHubAccount.defaultKey) -> GitHubAccount? {
        return Keychain.value(forKey: "gh") as GitHubAccount?
    }
    
    @discardableResult
    static func erase(key: String = GitHubAccount.defaultKey) -> Bool {
        return Keychain.removeValue(forKey: key)
    }
}
