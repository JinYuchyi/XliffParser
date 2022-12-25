//
//  TranslationItem.swift
//  XliffEditor
//
//  Created by Yuqi Jin on 2022/10/18.
//

import Foundation

public struct TransUnitItem: Identifiable, Comparable, Hashable {
    public let id: UUID
    public var transUnitIdStr: String
    public var restype: String
    public var source: String
    public var target: String


    public static func < (lhs: TransUnitItem, rhs: TransUnitItem) -> Bool {
        lhs.source < rhs.source
    }

    public init() {
        self.id = UUID()
        self.source = ""
        self.target = ""
        self.transUnitIdStr = ""
        self.restype = ""
    }

    public init(source: String, target: String, restype: String, transUnitIdStr: String) {
        self.id = UUID()
        self.source = source
        self.target = target
        self.restype = restype
        self.transUnitIdStr = transUnitIdStr
    }

}
