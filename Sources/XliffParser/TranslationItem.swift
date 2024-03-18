//
//  TranslationItem.swift
//  XliffEditor
//
//  Created by Yuqi Jin on 2022/10/18.
//

import Foundation

public struct TransUnitItem: Identifiable, Comparable, Hashable {
    public var id: String
    public var transUnitIdStr: String
    public var restype: String
    public var datatype: String
    public var source: String
    public var target: String
    public var sourceLanguage: String
    public var targetLanguage: String
    public var product: String
    public var xTrain: String
    public var origin: String

    public static func < (lhs: TransUnitItem, rhs: TransUnitItem) -> Bool {
        lhs.source < rhs.source
    }

    public init() {
        self.id = ""
        self.source = ""
        self.target = ""
        self.transUnitIdStr = ""
        self.restype = ""
        self.datatype = ""
        self.product = ""
        self.xTrain = ""
        self.sourceLanguage = ""
        self.targetLanguage = ""
        self.origin = ""
    }

    public init(source: String, target: String, restype: String, transUnitIdStr: String) {
        self.id = ""
        self.source = source
        self.target = target
        self.restype = restype
        self.transUnitIdStr = transUnitIdStr
        self.product = ""
        self.datatype = ""
        self.xTrain = ""
        self.sourceLanguage = ""
        self.targetLanguage = ""
        self.origin = ""
    }


}
