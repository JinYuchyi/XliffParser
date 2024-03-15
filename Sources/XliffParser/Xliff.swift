//
//  XmlParser.swift
//  XliffEditor
//
//  Created by Yuqi Jin on 2022/10/17.
//
import Foundation

//import XMLParser

public class Xliff: NSObject, XMLParserDelegate, Identifiable {

    private var sourceLanugage: String = ""
    private var targetLanguage: String = ""

    public var fileUrl: URL
    public var product: String = ""
    public var origin: String = ""
    public var x_path: String = ""
    public var trans: [TransUnitItem] = []

    private var tmpTranItem: TransUnitItem!
    private var currentElements: [String] = []
    private var lastCurrentElements: [String] = []
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
    
    init(sourceLanugage: String, targetLanguage: String, fileUrl: URL, product: String, origin: String, x_source: String) {
        self.sourceLanugage = sourceLanugage
        self.targetLanguage = targetLanguage
        self.fileUrl = fileUrl
        self.product = product
        self.origin = origin
        self.x_path = x_source
    }

    private var depth = 0
    private var depthIndent: String {
        return [String](repeating: "  ", count: self.depth).joined()
    }

    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: .whitespacesAndNewlines)

        if (currentElements.count > lastCurrentElements.count) && lastData == data {return}
        
        if currentElements.filter({$0 == ("source")}).count == 1 {
            let _content = tmpTranItem?.source ?? ""
            tmpTranItem?.source = _content + data
        } else if currentElements.filter({$0 == ("target")}).count == 1 {
            let _content = tmpTranItem?.target ?? ""
            tmpTranItem?.target = _content + data
        }
        lastCurrentElements = currentElements
        lastData = data

    }

    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if let _sourceLanugage = attributeDict["source-language"], let _targetLanugage = attributeDict["target-language"]  {
            sourceLanugage = _sourceLanugage
            targetLanguage = _targetLanugage
        }
        currentElements.append(elementName)
        if let _origin = attributeDict["origin"] {
            origin = _origin
        }

        if let _product = attributeDict["product"] {
            product = _product
        }

        if let _x_source = attributeDict["x-source-path"] {
            x_path = _x_source
        }

        if elementName == "trans-unit" {
            var tmp = TransUnitItem()
            tmp.sourceLanguage = sourceLanugage
            tmp.targetLanguage = targetLanguage
            tmp.transUnitIdStr = attributeDict["id"] ?? ""
            tmp.restype = attributeDict["restype"] ?? ""

            tmpTranItem = tmp
        }

    }

    public func parser(_ parser: XMLParser, didEndElement elementName: String,
                       namespaceURI: String?, qualifiedName qName: String?) {
        let _last = currentElements.removeLast()
        if _last == "trans-unit"{
            trans.append(tmpTranItem!)
        }
    }

    
}
