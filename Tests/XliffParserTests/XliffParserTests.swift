import XCTest
@testable import XliffParser

final class XliffParserTests: XCTestCase {
    let url = URL(fileURLWithPath: "/Users/jin/Downloads/SketchTest/XliffFiles/Rome/K/IASUtilities.xliff")
    var xliff: Xliff?

    
    override func setUp() {
        xliff = Xliff(fileUrl: url)
        if xliff == nil {
            XCTAssert(false, "Xliff init failed.")
        }
    }
    
    func testXliffDictTest() throws {
        let dict = xliff!.getTranslationDict()
//        print(dict.count)
        XCTAssertTrue(dict.count > 0 )
    }
    
    func testXliffXSource() throws {
        let dict = xliff!.getTranslationDict()
//        print(dict.count)
        XCTAssertTrue(xliff?.x_source != "" )
    }
    
    func testGetLanguage() throws {
        XCTAssertTrue(xliff!.sourceLanugage != "" &&  xliff!.targetLanguage != "")
    }
    func testXliffInBatch() throws {
        let folder: String = "/Users/jin/Downloads/XliffFiles/Rome/K"
        guard let paths = try? FileManager.default.subpathsOfDirectory(atPath: folder).filter({$0.contains(".xliff")}).map({folder + "/" + $0}) else {
            XCTAssert(false)
            return
        }
        for path in paths {
            xliff = Xliff(fileUrl: URL(fileURLWithPath: path))
            let dict = xliff!.getTranslationDict()
            if dict.count > 0 {
//                print(dict.count)
            } else {
                if !path.contains("_ignore"){
                    XCTAssert(false, "Empty: \(path)")
                }
            }
        }
    }
}


