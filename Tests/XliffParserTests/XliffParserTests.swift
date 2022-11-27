import XCTest
@testable import XliffParser

final class XliffParserTests: XCTestCase {
    let url = URL(fileURLWithPath: "/Users/jin/Downloads/T9_UserInput_Strings/CH/SydneyWhatsNew1C/SydneyWhatsNew1C.xliff")
    var xliff: Xliff?

    
    override func setUp() {
        xliff = Xliff(fileUrl: url)
        if xliff == nil {
            XCTAssert(false, "Xliff init failed.")
        }
    }
    
    func testXliffDictTest() throws {
        let dict = xliff!.getTranslationDict()
        print(dict.count)
        XCTAssertTrue(dict.count > 0 )
    }
    func testGetLanguage() throws {
        XCTAssertTrue(xliff!.sourceLanugage != "" &&  xliff!.targetLanguage != "")
    }
}


