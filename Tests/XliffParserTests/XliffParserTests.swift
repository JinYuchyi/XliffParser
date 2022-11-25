import XCTest
@testable import XliffParser

final class XliffParserTests: XCTestCase {
    var xliff = Xliff(fileUrl: url)
    let url = URL(fileURLWithPath: "/Users/jin/Downloads/T9_UserInput_Strings/CH/SydneyWhatsNew1C/SydneyWhatsNew1C.xliff")
    
    func initVal() {
        xliff = Xliff(fileUrl: url)
        if xliff == nil {
            XCTAssert(false, "Xliff init failed.")
        }
    }
    
    func testXliffDictTest() throws {
        initVal()
        let dict = xliff!.getTranslationDict()
        print(dict.count)
        XCTAssertTrue(dict.count > 0 )
    }
    func testGetLanguage() throws {
        let dict = xliff!.getTranslationDict()
        print(dict.count)
        XCTAssertTrue(dict.count > 0 )
    }
}


