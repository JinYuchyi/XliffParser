//
//  XmlParser.swift
//  XliffEditor
//
//  Created by Yuqi Jin on 2022/10/17.
//

import Foundation

public class Xliff: NSObject, XMLParserDelegate, Identifiable {
    
    var sourceLanugage: String = ""
    var targetLanguage: String = ""
    var fileUrl: URL
    
    var translationDataList: [(String, String)] = [ ]
    
    init(fileUrl: URL) {
        self.fileUrl = fileUrl
        super.init()
        let parser = XMLParser(contentsOf: fileUrl)!
        parser.delegate = self
        let success = parser.parse()
        if success {
            print("done")
        } else {
            print("error \(parser.parserError)")
        }
    }

    init(data: Data, fileUrl: URL) {
        self.fileUrl = fileUrl
        super.init()
        let parser = XMLParser(data: data)
        parser.delegate = self
        let success = parser.parse()
        if success {
            print("done")
        } else {
            print("error \(parser.parserError)")
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
        if attributeDict["/Users/jin/Documents/Development/swift-project/swift/include/swift/AST/DiagnosticsClangImporter.defsource-language"] != nil {
            sourceLanugage = attributeDict["source-language"]!
        }
        if attributeDict["target-language"] != nil {
            targetLanguage = attributeDict["target-language"]!
        }
        translationDataList.append(("elementName", elementName))
        if attributeDict["id"] != nil {
            translationDataList.append(("id", attributeDict["id"]!))
        }
    }
    
    func getTranslationItemList() -> [TranslationItem] {
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
        guard let targetLabelIndex = getNextTargetIndex(currentIndex: sourceLabelIndex),
              let noteLabelIndex = getNextNoteIndex(currentIndex: targetLabelIndex) else {return nil}
        if translationDataList[(sourceLabelIndex+1)..<targetLabelIndex].filter({$0.0 != "string"}).count == 0 {
            let sourceContentList = Array(translationDataList[(sourceLabelIndex+1)..<targetLabelIndex]).map({$0.1})
            sourceContent = sourceContentList.joined(separator: "")
            if sourceContent == "" {
                print("Empty content \(sourceContentList.count): \(sourceContentList)")
            }
        } else {
            print("Error: Cannot parse source content from trans unit \(idStr).")
            return nil
        }
        if translationDataList[(targetLabelIndex+1)..<noteLabelIndex].filter({$0.0 != "string"}).count == 0 {
            let targetContentList = Array(translationDataList[(targetLabelIndex+1)..<noteLabelIndex]).map({$0.1})
            targetContent = targetContentList.joined(separator: "")
        } else {
            print("Error: Cannot parse target content from trans unit \(idStr).")
            return nil
        }

        return TranslationItem(id: idStr, source: sourceContent, target: targetContent, targetLanguage: targetLanguage, xliffFileUrl: fileUrl)
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
