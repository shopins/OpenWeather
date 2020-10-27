import Foundation
import RealmSwift

func realmWrite(execute: @escaping (_ r: Realm) -> Void) {
    let realm = try! Realm()
    try! realm.write {
        execute(realm)
    }
}

func loadWeatherFromCache(city: City?) -> Weather? {
    let realm = try! Realm()
    if let city = city {
        return realm.object(ofType: Weather.self, forPrimaryKey: city.name)
    }
    return nil
}

func writeWeatherToCache(weather: Weather?) {
    realmWrite { realm in
        if let weather = weather {
                        realm.add(weather, update: .modified)
        }
    }
}

func markDataWeather (city: City, weather: Weather) -> Weather {
    deleteMarkedData(city: city)
    
    weather.city = city.name
    for day in weather.daily {
        day.city = city.name
        for w in day.weather {
            w.city = city.name
        }
        day.temp?.city = city.name
    }
    if let current = weather.current {
        current.city = city.name
        for w in current.weather {
            w.city = city.name
        }
    }
    return weather
}

func deleteMarkedData (city: City) {
    realmWrite { realm in
        realm.delete(realm.objects(Weather.self).filter("city == \"\(city.name)\""))
        realm.delete(realm.objects(WeatherElement.self).filter("city == \"\(city.name)\""))
        realm.delete(realm.objects(Temp.self).filter("city == \"\(city.name)\""))
        realm.delete(realm.objects(Daily.self).filter("city == \"\(city.name)\""))
        realm.delete(realm.objects(Current.self).filter("city == \"\(city.name)\""))
    }
}

 func convertDate(date: Int) -> String {
    let epochDate = Date(timeIntervalSince1970: TimeInterval(date))
    let calendar = Calendar.current
    let currentDay = calendar.component(.day, from: epochDate)
    let currentMonth = calendar.component(.month, from: epochDate)
return "\(currentDay)/\(currentMonth)"
}

extension Double {
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
