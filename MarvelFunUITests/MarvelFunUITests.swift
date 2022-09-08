//
//  MarvelFunUITests.swift
//  MarvelFunUITests
//
//  Created by Artem Demchenko on 04.09.2022.
//

import XCTest

class MarvelFunUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testComicsSort() throws {
        let app = XCUIApplication()
        app.launch()
        
        waitForNotZero(query: app.tables.cells, timeout: 10.0)
        
        let element = app.tables.cells.element(boundBy: 1)
        element.tap()
        
        let sortStaticText = "Sort"
        let sortButton = app.navigationBars.buttons[sortStaticText]
        XCTAssertTrue(sortButton.waitForExistence(timeout: 10.0), "\(sortStaticText) button not found")
        takeScreenshot()
        sortButton.tap()
        
        let titleStaticText = "Title"
        let titleButton = app.buttons[titleStaticText]
        XCTAssertTrue(titleButton.waitForExistence(timeout: 10.0), "\(titleStaticText) button not found")
        titleButton.tap()
        
        let checkTitleStaticText = "Hulk (2008) #55"
        let checkTitleTextElement = app.staticTexts[checkTitleStaticText]
        app.swipeUp()
        XCTAssertTrue(checkTitleTextElement.waitForExistence(timeout: 10.0), "\(checkTitleStaticText) title should be first")
        takeScreenshot()
        
        sortButton.tap()
        
        let dateStaticText = "Date"
        let dateButton = app.buttons[dateStaticText]
        XCTAssertTrue(dateButton.waitForExistence(timeout: 10.0), "\(dateStaticText) button not found")
        dateButton.tap()
        
        let checkDateStaticText = "Mar 20, 2013"
        let dateStaticTextElement = app.staticTexts[checkDateStaticText]
        app.swipeDown()
        XCTAssertTrue(dateStaticTextElement.waitForExistence(timeout: 10.0), "\(checkDateStaticText) date should be on top")
        takeScreenshot()
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
