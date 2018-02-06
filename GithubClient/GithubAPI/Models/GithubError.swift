//
//  GithubError.swift
//  GithubAPI
//
//  Created by Vasyl Liutikov on 06.02.2018.
//  Copyright © 2018 pingwinator. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct GithubError: JSONDecodableModel {
    
    fileprivate struct SerializationKeys {
        static let kMessage = "message"
    }
    
    let message : String
    
    public init(json: JSON) throws {
        message = try json[SerializationKeys.kMessage].value()
    }
}
