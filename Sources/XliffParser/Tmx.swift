//
//  File.swift
//  
//
//  Created by Yuqi Jin on 3/6/24.
//

import Foundation
public class Tmx: NSObject, XMLParserDelegate, Identifiable {

    public var sourceLanugage: String = ""
    public var targetLanguage: String = ""

    public var fileUrl: URL
    public var product: String = ""
    public var origin: String = ""
    public var xTrain: String = ""
    public var datatype: String = ""
    public var restype: String = ""
    public var id: String = ""
    public var trans: [TransUnitItem] = []

    private var tmpTranItem: TransUnitItem!
    private var currentAttributeType: String?
    private var currentAttributeValue: String?
    private var currentLanguageIndex: Int = 0
    private var isLanguageContent: Bool = false
    private var lastData: String = ""

    public init(fileUrl: URL) {
        self.fileUrl = fileUrl
        super.init()
        let parser = XMLParser(contentsOf: fileUrl)!
        parser.delegate = self
        let success = parser.parse()
        if !success {
            print("error: \(String(describing: parser.parserError?.localizedDescription))")
        }
    }


    public init(data: Data, fileUrl: URL) {
        self.fileUrl = fileUrl
        super.init()
        let parser = XMLParser(data: data)
        parser.delegate = self
        let success = parser.parse()
        if !success {
            print("error \(parser.parserError!.localizedDescription)")
        }
    }

    private var depth = 0
    private var depthIndent: String {
        return [String](repeating: "  ", count: self.depth).joined()
    }

    public func parser(_ parser: XMLParser, foundCharacters string: String) {
//        let data = string.trimmingCharacters(in: .whitespacesAndNewlines)
        currentAttributeValue = string

        // The source and translation content is from the "foundCharacter",
        // but we need the "elementName" as the indicator: when it's value is "seg", means the elementName's value is language content.
        if isLanguageContent {
            if currentLanguageIndex == 0 {
                tmpTranItem.source = string
            } else if currentLanguageIndex == 1 {
                tmpTranItem.target = string
            }
        }

    }

    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {

        if elementName == "tu" {
            tmpTranItem = TransUnitItem()
        }


        if elementName == "prop" {
            if attributeDict["type"] == "x-train" {
                currentAttributeType = "x-train"
            } else if attributeDict["type"] == "product-name" {
                currentAttributeType = "product-name"
            } else if attributeDict["type"] == "original" {
                currentAttributeType = "original"
            } else if attributeDict["type"] == "id" {
                currentAttributeType = "id"
            } else if attributeDict["type"] == "datatype" {
                currentAttributeType = "dataType"
            } else if attributeDict["type"] == "restype" {
                currentAttributeType = "restype"
            }
        }

        if elementName == "tuv" {
            if let text = attributeDict["xml:lang"] {
                if currentLanguageIndex == 0 {
                    tmpTranItem.sourceLanguage = text
                } else if currentLanguageIndex == 1 {
                    tmpTranItem.targetLanguage = text
                }
            }
        }

        if elementName == "seg" {
            isLanguageContent = true
        }
    }

    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "prop" {
            if currentAttributeType == "x-train" {
                tmpTranItem.xTrain = currentAttributeValue ?? ""
            } else if currentAttributeType == "product-name" {
                tmpTranItem.product = currentAttributeValue ?? ""
            } else if currentAttributeType == "original" {
                tmpTranItem.original = currentAttributeValue ?? ""
            } else if currentAttributeType == "id" {
                tmpTranItem.id = currentAttributeValue ?? ""
            } else if currentAttributeType == "restype" {
                tmpTranItem.restype = currentAttributeValue ?? ""
            } else if currentAttributeType == "source" {
                tmpTranItem.source = currentAttributeValue ?? ""
            }  else if currentAttributeType == "target" {
                tmpTranItem.target = currentAttributeValue ?? ""
            } else if currentAttributeType == "sourceLanguage" {
                tmpTranItem.sourceLanguage = currentAttributeValue ?? ""
            } else if currentAttributeType == "targetLanguage" {
                tmpTranItem.targetLanguage = currentAttributeValue ?? ""
            }
        } else if elementName == "tu" {
            trans.append(tmpTranItem)
        } else if elementName == "seg" {
            if currentLanguageIndex == 1 {
                isLanguageContent = false
                currentLanguageIndex = 0
            } else {
                currentLanguageIndex += 1
            }
        }
    }

}

enum TmxType {
    case xTrain //x-train
    case product //product-name
    case original // original
    case id // id
    case dataType // datatype
    case restype //restype
    case source // seg
    case target // seg
    case sourceLanguage // xml:lang
    case targetLanguage // xml:lang
}
