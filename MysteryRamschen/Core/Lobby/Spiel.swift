import Foundation

struct Spiel: Codable, Identifiable{
    var id: String
    var players: [String]
    var status: String
    var host: String
}
