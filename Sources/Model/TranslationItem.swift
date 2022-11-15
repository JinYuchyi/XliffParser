//
//  TranslationItem.swift
//  XliffEditor
//
//  Created by Yuqi Jin on 2022/10/18.
//

import Foundation

struct TranslationItem: Identifiable, Comparable, Hashable {
    static func < (lhs: TranslationItem, rhs: TranslationItem) -> Bool {
        lhs.source < rhs.source
    }

    let id: String
    var source: String
    var target: String
    var targetLanguage: String
    var xliffFileUrl: URL

}
