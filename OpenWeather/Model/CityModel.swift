import Foundation
import RealmSwift

func loadCityFromCache(cityName: String) -> City? {
    let realm = try! Realm()
    return realm.object(ofType: City.self, forPrimaryKey: cityName)
}

func writeCityToCache(city: City) {
    realmWrite { realm in
        realm.add(city, update: .modified)
    }
}

func downloadCityDataFromAPI(completion: @escaping () -> Void) {
    loadCityAlamofire { cityArray in
        if let cityArray = cityArray, !cityArray.isEmpty {
            for city in cityArray {
                writeCityToCache(city: city)
            }
            Persistance.shared.isLoadCities = true
        }
        completion()
    }
}

func getCurrentCity() -> City? {
    return loadCityFromCache(cityName: Persistance.shared.currentCity)
}

func getCitiesNameBySubjectFiltered(subject: String, filter: String) -> [String] {
    let realm = try! Realm()
    if filter == "" {
        return Array(realm.objects(City.self).filter("subject = %@", subject))
            .map { (city) -> String in
                city.name
            }
            .sorted()
    } else {
        return  Array(realm.objects(City.self).filter("subject = %@", subject).filter("name contains[cd] %@", filter))
        .map { (city) -> String in
            city.name
        }
        .sorted()
    }
}

func getSubjectsFiltered(filter: String) -> [String] {
    let realm = try! Realm()
    if filter == "" {
        return  distinct(Array(realm.objects(City.self))
            .map { (city) -> String in
                city.subject
            }).sorted()
    } else {
    return  distinct(Array(realm.objects(City.self).filter("name contains[cd] %@", filter))
        .map { (city) -> String in
            city.subject
        }).sorted()
    }
}


