//
//  SortedArray.swift
//  GithubClient
//
//  Created by Vasyl Liutikov on 06.02.2018.
//  Copyright © 2018 pingwinator. All rights reserved.
//

import Foundation
///Differ has issues with array of arrays like [[UserOverview]] so I added this wraper
struct SortedArray<T>: Equatable, RandomAccessCollection where T:Comparable {
    
    fileprivate let elements: [T]
    
    typealias Index = Int
    
    var startIndex: Int {
        return elements.startIndex
    }
    
    var endIndex: Int {
        return elements.endIndex
    }
    
    subscript(index: Int) -> T {
        return elements[index]
    }
    
    func index(after index: Int) -> Int {
        return elements.index(after: index)
    }
    
    var count: Int {
        return elements.count
    }
    
    var isEmpty: Bool {
        return elements.isEmpty
    }
    
    static func == (fst: SortedArray<T>, snd: SortedArray<T>) -> Bool {
        return fst.elements == snd.elements
    }
    
    init(_ elements:[T]) {
        self.elements = elements.sorted()
    }
}

extension SortedArray: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: SortedArray.Element...) {
        self.init(elements)
    }
}

extension SortedArray: CustomStringConvertible {
    var description: String {
        return elements.description
    }
}

extension SortedArray:  CustomDebugStringConvertible {
    var debugDescription: String {
        return elements.description
    }
}
