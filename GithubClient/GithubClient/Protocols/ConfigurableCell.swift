//
//  ConfigurableCell.swift
//  GithubClient
//
//  Created by Vasyl Liutikov on 06.02.2018.
//  Copyright © 2018 pingwinator. All rights reserved.
//

import Foundation
protocol ConfigurableCell {
    associatedtype Object
    func configure(object: Object)
}
