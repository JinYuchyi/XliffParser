//
//  TranslationItem.swift
//  XliffEditor
//
//  Created by Yuqi Jin on 2022/10/18.
//

import Foundation

public struct TranslationItem: Identifiable, Comparable, Hashable {
    public static func < (lhs: TranslationItem, rhs: TranslationItem) -> Bool {
        lhs.source < rhs.source
    }

    public init() {
        self.id = ""
        self.source = ""
        self.target = ""
        self.targetLanguage = ""
        self.xliffFileUrl = nil
    }
    public init(id: String, source: String, target: String, targetLanguage: String, xliffFileUrl: URL) {
        self.id = id
        self.source = source
        self.target = target
        self.targetLanguage = targetLanguage
        self.xliffFileUrl = xliffFileUrl
    }

    public let id: String
    public var source: String
    var target: String
    var targetLanguage: String
    var xliffFileUrl: URL?

}
