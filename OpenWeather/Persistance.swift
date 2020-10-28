
import Foundation

class Persistance{
    static let shared = Persistance()
    
    private let kCityKey = "Persistance.kCityKey"
    
    var city: String{
        set { UserDefaults.standard.set(newValue, forKey: kCityKey) }
        get { return UserDefaults.standard.string(forKey: kCityKey) ?? "" }
    }
    
}
