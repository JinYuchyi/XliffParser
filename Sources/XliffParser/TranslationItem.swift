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
    public var xliffFileUrl: URL?


    public static func < (lhs: TranslationItem, rhs: TranslationItem) -> Bool {
        lhs.source < rhs.source
    }

    public init() {
        self.id = ""
        self.source = ""
        self.target = ""
        self.targetLanguage = ""
        self.xliffFileUrl = nil
        self.product = ""
    }
    public init(id: String, source: String, target: String, targetLanguage: String, xliffFileUrl: URL, product: String) {
        self.id = id
        self.source = source
        self.target = target
        self.targetLanguage = targetLanguage
        self.xliffFileUrl = xliffFileUrl
        self.product = product
    }



}
