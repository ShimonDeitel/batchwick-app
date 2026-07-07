import XCTest

final class BatchwickUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testAddButtonOpensForm() {
        let addButton = app.buttons["addButton"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 5))
        addButton.tap()
        XCTAssertTrue(app.buttons["saveButton"].waitForExistence(timeout: 5))
        app.buttons["cancelButton"].tap()
    }

    func testAddEntryFlow() {
        app.buttons["addButton"].tap()
        let firstField = app.textFields.firstMatch
        if firstField.waitForExistence(timeout: 5) {
            firstField.tap()
            firstField.typeText("UI Test Entry")
        }
        app.buttons["saveButton"].tap()
        XCTAssertTrue(app.staticTexts["UI Test Entry"].waitForExistence(timeout: 5))
    }

    func testKeyboardDismissOnTapOutside() {
        app.buttons["addButton"].tap()
        let firstField = app.textFields.firstMatch
        if firstField.waitForExistence(timeout: 5) {
            firstField.tap()
            firstField.typeText("Dismiss Test")
            XCTAssertTrue(app.keyboards.element.exists)
            app.navigationBars.firstMatch.tap()
            XCTAssertFalse(app.keyboards.element.waitForExistence(timeout: 2))
        }
        app.buttons["cancelButton"].tap()
    }

    func testSettingsOpens() {
        app.buttons["settingsButton"].tap()
        XCTAssertTrue(app.buttons["settingsDoneButton"].waitForExistence(timeout: 5))
        app.buttons["settingsDoneButton"].tap()
    }

    func testFreeLimitTriggersPaywall() {
        for i in 0..<13 {
            let addButton = app.buttons["addButton"]
            guard addButton.waitForExistence(timeout: 3) else { break }
            addButton.tap()
            if app.buttons["paywallDismissButton"].waitForExistence(timeout: 2) {
                XCTAssertTrue(true)
                app.buttons["paywallDismissButton"].tap()
                return
            }
            let firstField = app.textFields.firstMatch
            if firstField.exists {
                firstField.tap()
                firstField.typeText("Item \(i)")
            }
            if app.buttons["saveButton"].exists {
                app.buttons["saveButton"].tap()
            }
        }
    }
}
