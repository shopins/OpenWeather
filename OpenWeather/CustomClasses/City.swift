
import Foundation
import RealmSwift

@objcMembers class City: Object, Codable {
    dynamic var name: String = ""
    dynamic var subject: String = ""
    dynamic var coords: Coords?
    
    enum CodingKeys: String, CodingKey {
        case name, subject, coords
    }
    override static func primaryKey() -> String?
    {
        return "name"
    }
}

@objcMembers class Coords: Object, Codable {
    dynamic var lat: String = ""
    dynamic var lon: String = ""
    
    enum CodingKeys: String, CodingKey {
        case lat, lon
    }
}

