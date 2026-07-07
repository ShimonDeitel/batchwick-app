import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published var items: [Batch] = []
    @Published var isPro: Bool = false

    static let freeLimit = 12

    private let fileURL: URL = {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir.appendingPathComponent("batchwick_items.json")
    }()

    init() {
        load()
        if items.isEmpty {
            items = [
            Batch(scentName: "Scent name 1", oilRatio: 10, containerSize: 10, baseType: "Base type 1", throwNotes: "Throw notes 1"),
            Batch(scentName: "Scent name 2", oilRatio: 13, containerSize: 13, baseType: "Base type 2", throwNotes: "Throw notes 2"),
            Batch(scentName: "Scent name 3", oilRatio: 16, containerSize: 16, baseType: "Base type 3", throwNotes: "Throw notes 3")
            ]
            save()
        }
    }

    var canAddMore: Bool {
        isPro || items.count < Store.freeLimit
    }

    func add(_ item: Batch) {
        items.insert(item, at: 0)
        save()
    }

    func update(_ item: Batch) {
        guard let idx = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[idx] = item
        save()
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }

    func delete(_ item: Batch) {
        items.removeAll { $0.id == item.id }
        save()
    }

    func load() {
        guard let data = try? Data(contentsOf: fileURL) else { return }
        if let decoded = try? JSONDecoder().decode([Batch].self, from: data) {
            items = decoded
        }
    }

    func save() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
}
