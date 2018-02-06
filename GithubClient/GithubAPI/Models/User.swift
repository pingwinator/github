//
//  User.swift
//  GithubAPI
//
//  Created by Vasyl Liutikov on 06.02.2018.
//  Copyright © 2018 pingwinator. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

public struct User: Codable, BasicUser {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    fileprivate struct SerializationKeys {
        static let login = "login"
        static let userId = "id"
        static let avatar = "avatar_url"
        static let url = "url"
        static let createdAt = "created_at"
        static let email = "email"
    }
    
    // MARK: Properties
    
    public var login: String
    public var userId: UInt
    public var avatar: String
    public var url: String
    public var createdAt: Date
    public var email: String?
}

extension User: JSONDecodableModel {
    /// Initiates the instance based on the JSON that was passed.
    ///
    /// - parameter json: JSON object from SwiftyJSON.
    public init(json: JSON) throws {
        userId = try json[SerializationKeys.userId].value()
        login = try json[SerializationKeys.login].value()
        avatar = try json[SerializationKeys.avatar].value()
        url = try json[SerializationKeys.url].value()
        createdAt = try json[SerializationKeys.createdAt].value()
        email = json[SerializationKeys.email].string
    }
}
