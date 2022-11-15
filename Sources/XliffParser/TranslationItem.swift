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

    public let id: String
    var source: String
    var target: String
    var targetLanguage: String
    var xliffFileUrl: URL

}
