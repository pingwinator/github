//
//  BasicUser.swift
//  GithubAPI
//
//  Created by Vasyl Liutikov on 06.02.2018.
//  Copyright © 2018 pingwinator. All rights reserved.
//

import Foundation

public protocol BasicUser {
    var login: String { get }
    var userId: UInt { get }
    var avatar: String { get }
    var url: String { get }
}
