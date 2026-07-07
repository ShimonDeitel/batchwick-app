import XCTest
@testable import Batchwick

@MainActor
final class BatchwickTests: XCTestCase {
    var store: Store!

    override func setUp() {
        super.setUp()
        store = Store()
    }

    func testSeedDataBelowFreeLimit() {
        XCTAssertLessThan(store.items.count, Store.freeLimit)
    }

    func testAddIncreasesCount() {
        let before = store.items.count
        store.add(Batch(scentName: "Test Entry"))
        XCTAssertEqual(store.items.count, before + 1)
    }

    func testDeleteDecreasesCount() {
        store.add(Batch(scentName: "To Delete"))
        let before = store.items.count
        store.delete(store.items[0])
        XCTAssertEqual(store.items.count, before - 1)
    }

    func testCanAddMoreWhenUnderLimit() {
        store.items = []
        XCTAssertTrue(store.canAddMore)
    }

    func testCannotAddMoreWhenAtLimitAndNotPro() {
        store.isPro = false
        store.items = (0..<Store.freeLimit).map { _ in Batch(scentName: "x") }
        XCTAssertFalse(store.canAddMore)
    }

    func testCanAddMoreWhenProEvenAtLimit() {
        store.isPro = true
        store.items = (0..<Store.freeLimit).map { _ in Batch(scentName: "x") }
        XCTAssertTrue(store.canAddMore)
    }

    func testUpdateModifiesItem() {
        store.add(Batch(scentName: "Original"))
        var item = store.items[0]
        item.scentName = "Updated"
        store.update(item)
        XCTAssertEqual(store.items[0].scentName, "Updated")
    }

    func testPersistenceRoundTrip() {
        store.add(Batch(scentName: "Persisted"))
        store.save()
        let reloaded = Store()
        XCTAssertTrue(reloaded.items.contains { $0.scentName == "Persisted" })
    }
}
