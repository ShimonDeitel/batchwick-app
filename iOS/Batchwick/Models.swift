import Foundation

struct Batch: Identifiable, Codable, Equatable {
    let id: UUID
    var dateCreated: Date
    var scentName: String
    var oilRatio: Double
    var containerSize: Double
    var baseType: String
    var throwNotes: String

    init(id: UUID = UUID(), dateCreated: Date = Date(), scentName: String = "", oilRatio: Double = 0, containerSize: Double = 0, baseType: String = "", throwNotes: String = "") {
        self.id = id
        self.dateCreated = dateCreated
        self.scentName = scentName
        self.oilRatio = oilRatio
        self.containerSize = containerSize
        self.baseType = baseType
        self.throwNotes = throwNotes
    }
}
