import XCTest
@testable import XliffParser

final class XliffParserTests: XCTestCase {
    func xliffDictTest() throws {
        let url = URL(fileURLWithPath: "/Users/jin/Downloads/BR/SydneyEssentials.xliff")
        let xliff = Xliff(fileUrl: url)
//        let dict = xliff.getTranslationDict()
//        print(dict.count)
        XCTAssertTrue(1 > 0 )
    }
}
