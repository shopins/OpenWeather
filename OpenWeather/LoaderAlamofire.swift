
import Foundation
import Alamofire

func AFRequestData(url : String, data: @escaping (Data?) -> Void )
{
    AF.request(url).response { response in
        switch response.result
        {
        case .success:
            data(response.data)
        case .failure(let error):
            print("Failed loading data: ", error)
        }
    }
}

func loadWeatherAlamofire(city: City, completion: @escaping (Weather) -> Void) {
    if let coords = city.coords {
    let urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(coords.lat)&lon=\(coords.lon)&exclude=minutely,hourly,alerts&lang=ru&units=metric&appid=f4f83716824d96e662b7c9214adfe2d1"
    AFRequestData(url: urlString) { data in
        if let data = data,
           let weather = try? JSONDecoder().decode(Weather.self, from: data) {
                DispatchQueue.main.async {
                    completion(weather)
                }
            }
        }
    }
}

func loadCityAlamofire(completion: @escaping ([City]) -> Void) {
    let urlString = "https://raw.githubusercontent.com/pensnarik/russian-cities/master/russian-cities.json"
    AFRequestData(url: urlString) { data in
        if let data = data,
           let city = try? JSONDecoder().decode([City].self, from: data) {
                DispatchQueue.main.async {
                    completion(city)
                }
            }
        }
}

func loadImage(icon: String, completion: @escaping (UIImage?) -> Void) {
    let urlString = "https://openweathermap.org/img/wn/\(icon)@2x.png"
    AFRequestData(url: urlString) { data in
        if let data = data {
            completion(UIImage(data: data))
        }
    }
}

