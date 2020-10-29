import Foundation
import RealmSwift

func loadWeatherFromCache(cityName: String) -> Weather? {
    let realm = try! Realm()
        return realm.object(ofType: Weather.self, forPrimaryKey: cityName)
}

func writeWeatherToCache(weather: Weather) {
    realmWrite { realm in
        realm.add(weather, update: .modified)
    }
}

func markDataWeather (cityName: String, weather: Weather) -> Weather {
    
    deleteMarkedData(cityName: cityName)
    
    weather.city = cityName
    for day in weather.daily {
        day.city = cityName
        for w in day.weather {
            w.city = cityName
        }
        day.temp?.city = cityName
    }
    if let current = weather.current {
        current.city = cityName
        for w in current.weather {
            w.city = cityName
        }
    }
    return weather
}

func deleteMarkedData (cityName: String) {
    realmWrite { realm in
        realm.delete(realm.objects(Weather.self).filter("city = %@", cityName))
        realm.delete(realm.objects(WeatherElement.self).filter("city = %@", cityName))
        realm.delete(realm.objects(Temp.self).filter("city = %@", cityName))
        realm.delete(realm.objects(Daily.self).filter("city = %@", cityName))
        realm.delete(realm.objects(Current.self).filter("city = %@", cityName))
    }
}

 
