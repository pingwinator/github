//
//  UserOverview.swift
//  GithubAPI
//
//  Created by Vasyl Liutikov on 06.02.2018.
//  Copyright © 2018 pingwinator. All rights reserved.
//

import Alamofire
import Foundation
import SwiftyJSON

public struct UserOverview: Codable, Equatable, BasicUser, Comparable {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    fileprivate struct SerializationKeys {
        static let login = "login"
        static let userId = "id"
        static let avatar = "avatar_url"
        static let url = "url"
    }
    
    // MARK: Properties
    
    public var login: String
    public var userId: UInt
    public var avatar: String
    public var url: String
    
    public static func == (lhs: UserOverview, rhs: UserOverview) -> Bool {
        return lhs.userId == rhs.userId
    }
    
    public static func < (lhs: UserOverview, rhs: UserOverview) -> Bool {
        return lhs.login < rhs.login
    }
}

extension UserOverview: URLRequestConvertible {
    
    public func asURLRequest() throws -> URLRequest {
        let url1 = try url.asURL()
        return URLRequest(url: url1)
    }
}

extension UserOverview: JSONDecodableModel {
    /// Initiates the instance based on the JSON that was passed.
    ///
    /// - parameter json: JSON object from SwiftyJSON.
    public init(json: JSON) throws {
        self.userId = try json[SerializationKeys.userId].value()
        self.login = try json[SerializationKeys.login].value()
        self.avatar = try json[SerializationKeys.avatar].value()
        self.url = try json[SerializationKeys.url].value()
    }
}
