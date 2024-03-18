//
//  TmxTests.swift
//  
//
//  Created by Yuqi Jin on 3/11/24.
//

import XCTest
@testable import XliffParser

final class TmxTests: XCTestCase {

    let url = URL(fileURLWithPath: "/Users/jin/Documents/NovaTest/BorealisF_tmx_de.tmx")
    var tmx: Tmx?

    override func setUpWithError() throws {
        tmx = Tmx(fileUrl: url)
        if tmx == nil {
            XCTAssert(false, "Tmx init failed.")
        }
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTmxCreationTest() throws {
        guard let trans = tmx?.trans else {
            print("No trans can be fetched.")
            return
        }
        let index = (0...trans.count).randomElement() ?? 0
        let sourceContained = (trans[index].source != "")
        let targetContained = (trans[index].target != "")
        let idContained = (trans[index].id != "")
        let transUnitIdStrContained = (trans[index].transUnitIdStr != "")
        let restypeContained = (trans[index].restype != "")
        let sourceLanguageContained = (trans[index].sourceLanguage != "")
        let targetLanguageContained = (trans[index].targetLanguage != "")
        let productContained = (trans[index].product != "")
        let xTrainContained = (trans[index].xTrain != "")
        let originalContained = (trans[index].origin != "")

        let result = sourceContained && targetContained && idContained && transUnitIdStrContained &&
        restypeContained && sourceLanguageContained && targetLanguageContained && productContained &&
        xTrainContained && originalContained

        XCTAssert(result, "Tmx test failed.")

    }

}
