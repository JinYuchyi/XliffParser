//
//  TranslationItem.swift
//  XliffEditor
//
//  Created by Yuqi Jin on 2022/10/18.
//

import Foundation

public struct TranslationItem: Identifiable, Comparable, Hashable {
    public let id: String
    public var source: String
    public var target: String
    public var targetLanguage: String
    public var product: String
    public var xliffFileUrl: String
    public var origin: String
    public var x_path: String


    public static func < (lhs: TranslationItem, rhs: TranslationItem) -> Bool {
        lhs.source < rhs.source
    }

    public init() {
        self.id = ""
        self.source = ""
        self.target = ""
        self.targetLanguage = ""
        self.xliffFileUrl = ""
        self.product = ""
        self.origin = ""
        self.x_path = ""
    }
    public init(id: String, source: String, target: String, targetLanguage: String, xliffFileUrl: String, product: String, origin: String, x_path: String) {
        self.id = id
        self.source = source
        self.target = target
        self.targetLanguage = targetLanguage
        self.xliffFileUrl = xliffFileUrl
        self.product = product
        self.origin = origin
        self.x_path = x_path
    }



}
