//
//  Weather.swift
//  SkillboxLesson12
//
//  Created by Сергей Шопин on 03.10.2020.
//

import Foundation
import RealmSwift

@objcMembers class WeatherElement: Object, Codable {
    dynamic var city: String = ""
    dynamic var weatherDescription : String = ""
    dynamic var icon : String = ""

    enum CodingKeys: String, CodingKey {
        case weatherDescription = "description"
        case icon
    }
}

@objcMembers class Temp: Object, Codable {
    dynamic var city: String = ""
    dynamic var day: Double = 0
    dynamic var night: Double = 0
    
    enum CodingKeys: String, CodingKey {
        case day, night
    }
}

@objcMembers class Current: Object, Codable {
    dynamic var city: String = ""
    dynamic var temp: Double = 0
    dynamic var windSpeed: Double = 0
    dynamic var pressure: Int = 0
    dynamic var humidity: Int = 0
    dynamic var unixDate: Int = 0
    dynamic var weather = List<WeatherElement>()

    enum CodingKeys: String, CodingKey {
        case temp, pressure, humidity, weather
        case windSpeed = "wind_speed"
        case unixDate = "dt"
    }
}

@objcMembers class Daily: Object, Codable {
    dynamic var city: String = ""
    dynamic var temp: Temp?
    dynamic var pressure: Int = 0
    dynamic var humidity: Int = 0
    dynamic var unixDate: Int = 0
    dynamic var windSpeed: Double = 0
    dynamic var weather = List<WeatherElement>()
    
    enum CodingKeys: String, CodingKey {
        case temp, pressure, humidity, weather
        case windSpeed = "wind_speed"
        case unixDate = "dt"
    }
}

@objcMembers class Weather: Object, Codable {
    dynamic var city: String = ""
    dynamic var lastUpdate: Date = Date()
    dynamic var current: Current?
    dynamic var daily = List<Daily>()
    
    enum CodingKeys: String, CodingKey {
        case current, daily
    }
    override static func primaryKey() -> String?
    {
        return "city"
    }
}
