//
//  XCTestCase+Extension.swift
//  MarvelFunUITests
//
//  Created by Artem Demchenko on 09.09.2022.
//

import XCTest

extension XCTestCase {
    func waitForKeyboardFocus(in textField: XCUIElement) {
        let focusExpectation = expectation(
            for: NSPredicate(format: "self.hasKeyboardFocus = true"),
            evaluatedWith: textField,
            handler: nil)
        wait(for: [focusExpectation], timeout: 10.0)
    }
    
    func waitForNotZero(query: XCUIElementQuery, timeout: TimeInterval = 5.0, handler: XCTNSPredicateExpectation.Handler? = nil) {
        let predicate = NSPredicate(format: "self.count > 0")
        waitForNotZero(query: query, predicate: predicate, timeout: timeout, handler: handler)
    }

    func waitForNotZero(query: XCUIElementQuery, predicate: NSPredicate, timeout: TimeInterval = 5.0, handler: XCTNSPredicateExpectation.Handler? = nil) {
        let elementsExpectation = expectation(
            for: predicate,
            evaluatedWith: query,
            handler: handler)
        wait(for: [elementsExpectation], timeout: timeout)
    }

    func waitForNotZero(object: Any, timeout: TimeInterval = 5.0, handler: XCTNSPredicateExpectation.Handler? = nil) {
        let elementsExpectation = expectation(
            for: NSPredicate(format: "self.count > 0"),
            evaluatedWith: object,
            handler: handler)
        wait(for: [elementsExpectation], timeout: timeout)
    }
    
    func waitFor(numberOfElements count: Int, query: XCUIElementQuery, timeout: TimeInterval = 5.0, handler: XCTNSPredicateExpectation.Handler? = nil) {
        let cellsExpectation = expectation(
            for: NSPredicate(format: "self.count = \(count)"),
            evaluatedWith: query,
            handler: handler)
        wait(for: [cellsExpectation], timeout: timeout)
    }

    func wait(_ timeout: Double = 5) {
        let delayExpectation = expectation(description: "Waiting for document to be saved")
        // Fulfill the expectation after 10 seconds
        // (which matches our document save interval)
        DispatchQueue.main.asyncAfter(deadline: .now() + timeout) {
            delayExpectation.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }
    
    func takeScreenshot() {
        let screenshot = XCUIScreen.main.screenshot()
        let fullScreenshotAttachment = XCTAttachment(screenshot: screenshot)
        fullScreenshotAttachment.lifetime = .deleteOnSuccess
        add(fullScreenshotAttachment)
    }
}
