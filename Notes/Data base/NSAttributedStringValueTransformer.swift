//
//  NSAttributedStringValueTransformer.swift
//  Notes
//
//  Created by Kirill on 27.09.2023.
//

import Foundation



// MARK: Value transformer для преоразования типа NSAttributedString
// Читай "https://www.kairadiagne.com/2020/01/13/nssecurecoding-and-transformable-properties-in-core-data.html"

@objc(NSAttributedStringValueTransformer)
final class NSAttributedStringValueTransformer: NSSecureUnarchiveFromDataTransformer {

    static let name = NSValueTransformerName(rawValue: String(describing: NSAttributedStringValueTransformer.self))

    override static var allowedTopLevelClasses: [AnyClass] {
        return [NSAttributedString.self]
    }

    static func register() {
        let transformer = NSAttributedStringValueTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}


