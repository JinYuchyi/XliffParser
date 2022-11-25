//
//  XmlParser.swift
//  XliffEditor
//
//  Created by Yuqi Jin on 2022/10/17.
//

import Foundation

public class Xliff: NSObject, XMLParserDelegate, Identifiable {
    
    public var sourceLanugage: String = ""
    public var targetLanguage: String = ""
    public var fileUrl: URL
    
    public var translationDataList: [(String, String)] = [ ]
    
    public var translationDict: [String: [String]] = [:]


    public init(fileUrl: URL) {
        self.fileUrl = fileUrl
        super.init()
        let parser = XMLParser(contentsOf: fileUrl)!
        parser.delegate = self
        let success = parser.parse()
        if success {
            print("done")
        } else {
            print("error \(String(describing: parser.parserError?.localizedDescription))")
        }
    }
    

    public init(data: Data, fileUrl: URL) {
        self.fileUrl = fileUrl
        super.init()
        let parser = XMLParser(data: data)
        parser.delegate = self
        let success = parser.parse()
        if success {
            print("done")
        } else {
            print("error \(parser.parserError!.localizedDescription)")
        }
    }
    
    
    var depth = 0
    var depthIndent: String {
        return [String](repeating: "  ", count: self.depth).joined()
    }

    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        translationDataList.append(("string", string))
    }

    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
//        sourceLanugage = attributeDict["source-language"] ?? ""
//        targetLanguage = attributeDict["target-language"] ?? ""
        if elementName == "file" {
            guard let _sourceLanugage = attributeDict["source-language"], let _targetLanugage = attributeDict["target-language"] else {
                print("Error: Cannot find source/target language.")
                return
            }
            sourceLanugage = _sourceLanugage
            targetLanguage = _targetLanugage
        }
        
        translationDataList.append(("elementName", elementName))
        if attributeDict["id"] != nil {
            translationDataList.append(("id", attributeDict["id"]!))
        }
    }
    
    //[En-Content: [LocalizedContent: Language ]]
    public func getTranslationDict(itemList: [TranslationItem]? = nil) -> [String: [String: String]] {
        var result: [String: [String: String]] = [:]
        var list: [TranslationItem] = []
        if itemList == nil {
            list = getTranslationItemList()
        } else {
            list = itemList!
        }
        for item in list {
            let tmpItem = [item.target : item.targetLanguage ]
            if result[item.source] == nil {
                result[item.source] = tmpItem
            } else {
                result[item.source]![item.target] = item.targetLanguage
            }
        }
        return result
    }
    
    public func getTranslationItemList() -> [TranslationItem] {
        var result: [TranslationItem] = []
        var currentIndex = 0

        while (currentIndex <= (translationDataList.count - 1) ) {
            guard let transUnitIndex = getNextValidTransUnitIndex(currentIndex: currentIndex)
            else { break}
            guard let item = getValidTransUnitElements(unitIndex: transUnitIndex) else {
                currentIndex = transUnitIndex
                continue
            }
            result.append(item)
            currentIndex = transUnitIndex
        }
        return result
    }

    private func getNextValidTransUnitIndex(currentIndex: Int) -> Int? {
        if (currentIndex+1) >= (translationDataList.count - 1) {
            return nil
        }
        for index in (currentIndex+1)..<translationDataList.count {
            if translationDataList[index].1 == "trans-unit"  {
                guard let idIndex = getNextIdIndex(currentIndex: index) else {return nil}
                if isValidIdString(idStr: translationDataList[idIndex].1)  {
                    return index
                }
            }
        }
        return nil
    }

    private func getValidTransUnitElements(unitIndex: Int) -> TranslationItem? {
        var idStr = ""
        var sourceContent = ""
        var targetContent = ""
        let idIndex = unitIndex + 1
        if translationDataList[idIndex].0 == "id" && isValidIdString(idStr: translationDataList[idIndex].1) {
            idStr = translationDataList[idIndex].1
        }
        let sourceLabelIndex = unitIndex + 2
        guard let targetLabelIndex = getNextTargetIndex(currentIndex: sourceLabelIndex) else {return nil}
        // Get content end border
        guard let source_end = getContentEndBorderIndex(currentIndex: sourceLabelIndex) else {return nil}
        guard let target_end = getContentEndBorderIndex(currentIndex: targetLabelIndex) else {return nil}
//        if translationDataList[(sourceLabelIndex+1)..<end].filter({$0.0 != "string"}).count == 0 {
//            let sourceContentList = Array(translationDataList[(sourceLabelIndex+1)..<targetLabelIndex]).map({$0.1})
//            sourceContent = sourceContentList.joined(separator: "")
//            if sourceContent == "" {
//                print("Empty content \(sourceContentList.count): \(sourceContentList)")
//            }
//        } else {
//            print("Error: Cannot parse source content from trans unit \(idStr).")
//            return nil
//        }
        guard let _sourceContent = combineContent(translationDataList: translationDataList, start: sourceLabelIndex+1, end: source_end) else {return nil}
        sourceContent = _sourceContent
        
//        if translationDataList[(targetLabelIndex+1)..<noteLabelIndex].filter({$0.0 != "string"}).count == 0 {
//            let targetContentList = Array(translationDataList[(targetLabelIndex+1)..<noteLabelIndex]).map({$0.1})
//            targetContent = targetContentList.joined(separator: "")
//        } else {
//            print("Error: Cannot parse target content from trans unit \(idStr).")
//            return nil
//        }
        guard let _targetContent = combineContent(translationDataList: translationDataList, start: targetLabelIndex+1, end: target_end) else {return nil}
        targetContent = _targetContent

        return TranslationItem(id: idStr, source: sourceContent, target: targetContent, targetLanguage: targetLanguage, xliffFileUrl: fileUrl)
    }
    
    private func combineContent(translationDataList: [(String, String)], start: Int, end: Int) -> String? {
        if start >= translationDataList.count || start > end || end >= translationDataList.count {
            return nil
        }
        if translationDataList[start...end].filter({$0.0 != "string"}).count != 0 {
            print("Error: Cannot parse source content from trans unit.")
            return nil
        }
        let contentList = Array(translationDataList[start...end]).map({$0.1})
        let content = contentList.joined(separator: "")
        if content == "" {
            print("Empty content \(content.count): \(contentList)")
            return nil
        }
        return content
    }
    
    private func getContentEndBorderIndex(currentIndex: Int) -> Int? {
        for index in currentIndex+1..<(translationDataList.count - 1) {
            if translationDataList[index].0 == "string" && translationDataList[index+1].0 != "string" {
                return index
            }
        }
        return nil
    }

    private func isValidIdString(idStr: String) -> Bool {
        if !idStr.isEmpty {return true}
        return false
    }

    private func getNextIdIndex(currentIndex: Int) -> Int? {
        if (currentIndex+1) >= (translationDataList.count - 1) {
            return nil
        }
        for index in (currentIndex+1)..<translationDataList.count {
            if translationDataList[index].0 == "id"  {
                return index
            }
        }
        return nil
    }

    private func getNextTargetIndex(currentIndex: Int) -> Int? {
        if (currentIndex+1) >= (translationDataList.count - 1) {
            return nil
        }
        for index in (currentIndex+1)..<translationDataList.count {
            if translationDataList[index].0 == "elementName" && translationDataList[index].1 == "target" {
                return index
            }
        }
        return nil
    }

    private func getNextSourceIndex(currentIndex: Int) -> Int? {
        if (currentIndex+1) >= (translationDataList.count - 1) {
            return nil
        }
        for index in (currentIndex+1)..<translationDataList.count {
            for elem in translationDataList {
                print("\(elem.0) - \(elem.1)")
            }
            if translationDataList[index].0 == "elementName" && translationDataList[index].1 == "source" {
                return index
            }
        }
        return nil
    }

    private func getNextNoteIndex(currentIndex: Int) -> Int? {
        if (currentIndex+1) >= (translationDataList.count - 1) {
            return nil
        }
        for index in (currentIndex+1)..<translationDataList.count {
            if translationDataList[index].0 == "elementName" && translationDataList[index].1 == "note" {
                return index
            }
        }
        return nil
    }

    private func getNextNotSourceAndTargetIndex(currentIndex: Int) -> Int? {
        if (currentIndex+1) >= (translationDataList.count - 1) {
            return nil
        }
        for index in (currentIndex+1)..<translationDataList.count {
            if translationDataList[index].0 == "elementName" && translationDataList[index].1 != "source" && translationDataList[index].1 != "target" {
                return index
            }
        }
        return nil
    }

    
}
