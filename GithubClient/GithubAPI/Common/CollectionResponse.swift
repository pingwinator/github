//
//  CollectionResponse.swift
//  GithubAPI
//
//  Created by Vasyl Liutikov on 06.02.2018.
//  Copyright © 2018 pingwinator. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct CollectionResponse<T: JSONDecodableModel>: JSONDecodableModel {
    public let data: [T]
    public init(json: JSON) throws {
        let subscriptionsArray = json.arrayValue
        data = try subscriptionsArray.map({ try T(json: $0) })
    }
}
