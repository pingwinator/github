//
//  SwiftyHelper.swift
//  GithubAPI
//
//  Created by Vasyl Liutikov on 06.02.2018.
//  Copyright © 2018 pingwinator. All rights reserved.
//

// original idea https://github.com/alickbass/SwiftyJSONModel

import Foundation
import SwiftyJSON
import AFDateHelper

extension JSON {
    public func value(_ file: String = #file, _ line: UInt = #line) throws -> Bool {
        guard let boolValue = bool else { throw VLError.mapping(error(file: file, line: line)) }
        return boolValue
    }
    public func value(_ file: String = #file, _ line: UInt = #line) throws -> Int {
        guard let intValue = int else { throw VLError.mapping(error(file: file, line: line)) }
        return intValue
    }
    public func value(_ file: String = #file, _ line: UInt = #line) throws -> UInt {
        guard let intValue = uInt else { throw VLError.mapping(error(file: file, line: line)) }
        return intValue
    }
    public func value(_ file: String = #file, _ line: UInt = #line) throws -> Double {
        guard let doubleValue = double else { throw VLError.mapping(error(file: file, line: line)) }
        return doubleValue
    }
    public func value(_ file: String = #file, _ line: UInt = #line) throws -> String {
        guard let stringValue = string else { throw VLError.mapping(error(file: file, line: line)) }
        return stringValue
    }
    public func value(format: DateFormatType = .isoDateTimeSec, _ file: String = #file, _ line: UInt = #line) throws -> Date {
        guard let stringValue = string, let date = Date(fromString: stringValue, format: format)
            else { throw VLError.mapping(error(file: file, line: line))  }
        return date
    }
    
    public func arrayValue(_ file: String = #file, _ line: UInt = #line) throws -> [JSON] {
        guard let arrayValue = array else { throw VLError.mapping(error(file: file, line: line)) }
        return arrayValue
    }
    public func dictionaryValue(_ file: String = #file, _ line: UInt = #line) throws -> [String: JSON] {
        guard let dictValue = dictionary else { throw VLError.mapping(error(file: file, line: line)) }
        return dictValue
    }
    fileprivate func error(file: String, line: UInt) -> String {
        return "File: \((file as NSString).lastPathComponent) --- Line: \(line)"
    }
}
