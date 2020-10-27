//
//  WeatherModel.swift
//  SkillboxLesson14
//
//  Created by Сергей Шопин on 25.10.2020.
//

import Foundation
import Alamofire
import RealmSwift

var weather: Weather?


func loadRealmData(city: City?) {
    if let city = city {
        weather = realm.object(ofType: Weather.self, forPrimaryKey: city.name)
    }
}

func writeRealmData() {
        try! realm.write {
            if let weather = weather {
                realm.add(weather, update: .modified)
            }
        }
}

func markDataWeather (city: City, tempWeather: Weather) {
    deleteMarkedData(city: city)
    
    tempWeather.lastUpdate = Date()
    tempWeather.city = city.name
    for day in tempWeather.daily {
        day.city = city.name
        for w in day.weather {
            w.city = city.name
        }
        day.temp?.city = city.name
    }
    if let current = tempWeather.current {
        current.city = city.name
        for w in current.weather {
            w.city = city.name
        }
    }
    weather = tempWeather
}

func deleteMarkedData (city: City) {
    try! realm.write {
        realm.delete(realm.objects(Weather.self).filter("city == \"\(city.name)\""))
        realm.delete(realm.objects(WeatherElement.self).filter("city == \"\(city.name)\""))
        realm.delete(realm.objects(Temp.self).filter("city == \"\(city.name)\""))
        realm.delete(realm.objects(Daily.self).filter("city == \"\(city.name)\""))
        realm.delete(realm.objects(Current.self).filter("city == \"\(city.name)\""))
    }
}


 func loadImage(icon: String?) -> UIImage? {
    var image : UIImage?
    let sem = DispatchSemaphore(value: 0)
    guard let icon = icon,
          let url = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png") else { sem.signal(); return nil }
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        if error != nil {
            print("Failed fetching image:", error!)
            sem.signal()
            return
        }
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            print("Not a proper HTTPURLResponse or statusCode")
            sem.signal()
            return
        }
        if let data = data {
            image = UIImage(data: data)
            sem.signal()
        }
    }.resume()
    sem.wait()
return image
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
