//
//  Array+Extensions.swift
//  PlatformKit
//
//  Created by Jack on 24/09/2019.
//  Copyright © 2019 Blockchain Luxembourg S.A. All rights reserved.
//

import Foundation
import Foundation

extension Array {

    /// Randomly picks the given amount of elements.
    ///
    /// - parameter amount: The amount of elements to pick. 
    public func pick(_ amount: Int) -> Array<Element> {
        Array(shuffled().prefix(amount))
    }
}

// MARK: - Hashable

extension Array where Element: Hashable {
    public var duplicates: Array<Element>? {
        let dictionary = Dictionary(grouping: self, by: { $0 })
        let pairs = dictionary.filter { $1.count > 1 }
        let duplicates = Array(pairs.keys)
        return duplicates.count > 0 ? duplicates : nil
    }
}

// MARK: - Equatable

extension Array where Element: Equatable {
    public var areAllElementsEqual: Bool {
        guard let first = self.first else { return true }
        return !dropFirst().contains { $0 != first }
    }
    
    /// Returns `true` if if all elements are equal to a given value
    public func areAllElements(equal element: Element) -> Bool {
        !contains { $0 != element }
    }
}

// MARK: - String

extension Array where Element == String {
    public var containsEmpty: Bool {
        contains("")
    }
}

/// Array extensions.
extension Array {

    /// Remove the given element from this array, by comparing pointer references.
    ///
    /// - parameter element: The element to remove.
    public mutating func removeElementByReference(_ element: Element) {
        guard let objIndex = firstIndex(where: { $0 as AnyObject === element as AnyObject }) else {
            return
        }
        remove(at: objIndex)
    }
}
