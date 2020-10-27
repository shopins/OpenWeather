//
//  City.swift
//  SkillboxLesson12
//
//  Created by Сергей Шопин on 03.10.2020.
//

import Foundation

struct City {
    let name: String
    let lat: Double
    let lon: Double
    let timezone: String
}

struct CityData {
    static func get(name: String) -> City? {
        switch name {
        case "Москва": return City(name: "Москва", lat: 55.76, lon: 37.62, timezone: "Europe/Moscow")
        case "Хабаровск": return City(name: "Хабаровск", lat: 44.48, lon: 135.07, timezone: "Asia/Vladivostok")
            default: return nil
        }
    }
}
