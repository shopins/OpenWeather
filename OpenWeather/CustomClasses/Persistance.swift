
import Foundation

class Persistance{
    static let shared = Persistance()
    
    private let kCityKey = "Persistance.kCityKey"
    private let kLoadCityKey = "Persistance.kLoadCityKey"
    
    var currentCity: String{
        set { UserDefaults.standard.set(newValue, forKey: kCityKey) }
        get { return UserDefaults.standard.string(forKey: kCityKey) ?? "" }
    }
    
    var isLoadCities: Bool{
        set { UserDefaults.standard.set(newValue, forKey: kLoadCityKey) }
        get { return UserDefaults.standard.bool(forKey: kLoadCityKey) }
    }
    
}
