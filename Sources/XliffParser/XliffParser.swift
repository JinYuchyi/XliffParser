//
//  File.swift
//  
//
//  Created by Yuqi Jin on 2022/11/25.
//

import Foundation
public struct XliffParser {
    public private(set) var text = "Hello, World!"

    public init() {
        let url = URL(fileURLWithPath: "/Users/jin/Downloads/BR/SydneyEssentials.xliff")
        let xliff = Xliff(fileUrl: url)
        let dict = xliff.getTranslationDict()
        print(dict.count)
    }
}
