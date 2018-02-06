//
//  SearchTerms.swift
//  GithubAPI
//
//  Created by Vasyl Liutikov on 06.02.2018.
//  Copyright © 2018 pingwinator. All rights reserved.
//

import Foundation

public enum SearchTerms {
    case language(String)
    case type(String)
    /// any search string
    case custom(String)
    // other types not implemented, but you could find it at https://developer.github.com/v3/search/#search-users
    
    public init(_ string: String) {
        self = .custom(string)
    }
}

extension SearchTerms: RawRepresentable {
    
    public init(rawValue: String) {
        self = .custom(rawValue)
    }
    public var rawValue: String {
        switch self {
        case .language(let lang):
            return "language:" + lang
        case .type(let type):
            return "type:" + type
        case .custom(let string):
            return string
        }
    }
    
}
extension SearchTerms: ExpressibleByStringLiteral {
    
    public init(stringLiteral value: StringLiteralType) {
        self = .custom(value)
    }
    
    public init(unicodeScalarLiteral value: String) {
        self.init(stringLiteral: value)
    }
    
    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(stringLiteral: value)
    }
}

extension SearchTerms: Hashable {
    public var hashValue: Int {
        return self.rawValue.hashValue
    }
    
    public static func == (lhs: SearchTerms, rhs: SearchTerms) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

extension SearchTerms: CustomStringConvertible {
    public var description: String {
        return self.rawValue
    }
}

public extension SearchTerms {
    public struct Languages {
        public static let java = "java"
        public static let swift = "swift"
    }
    
    public struct UserTypes {
        public static let user = "user"
        public static let organization = "org"
    }
}

public extension SearchTerms {
    ///predefined query for java language
    public static let javaLang = SearchTerms.language(Languages.java)
    ///predefines query for only users responce
    public static let user = SearchTerms.type(UserTypes.user)
}
