
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var forcastTableView: UITableView!
    
    @IBOutlet weak var updateLabel: UILabel!
    
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var pressureLabel: UILabel!
    
    @IBOutlet weak var humidityLabel: UILabel!
    
    @IBOutlet weak var windLabel: UILabel!
    
    @IBOutlet weak var weatherSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        forcastTableView.register(WeatherTableViewCell.nib, forCellReuseIdentifier: WeatherTableViewCell.ident)
        weatherSwitch.addTarget(self, action: #selector(changeValue), for: .valueChanged)
        
        let notificationCenter = NotificationCenter.default
            notificationCenter.addObserver(self, selector: #selector(appBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        if Persistance.shared.city == "Хабаровск" {
            weatherSwitch.isOn = true
        }
    }
    
    @objc func appBecomeActive() {
        if let city = getCity() {
            configLabels(weather: loadWeatherFromCache(city: city))
            downloadDataFromAPI(city: city, loader: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    private func downloadDataFromAPI(city: City?, loader : Bool) {
        if let city = city {
            if loader {
                loadWeatherStandard(city: city) { weather in
                    weather.lastUpdate = Date()
                    writeWeatherToCache(weather: markDataWeather(city: city, weather: weather))
                    self.configLabels(weather: weather)
                    self.forcastTableView.reloadData()
                   }
            } else {
                loadWeatherAlamofire(city: city) { weather in
                    weather.lastUpdate = Date()
                    writeWeatherToCache(weather: markDataWeather(city: city, weather: weather))
                    self.configLabels(weather: weather)
                    self.forcastTableView.reloadData()
                   }
            }
        }
    }

    private func configLabels(weather: Weather?) {
        if let lastUpdate = weather?.lastUpdate,
           let city = weather?.city,
           let temp = weather?.current?.temp,
           let description = weather?.current?.weather.first?.weatherDescription,
           let pressure = weather?.current?.pressure,
           let humidity = weather?.current?.humidity,
           let wind = weather?.current?.windSpeed
           {
            let formatter = DateFormatter()
                formatter.dateStyle = .long
                formatter.timeStyle = .medium
                formatter.locale = Locale(identifier: "ru_RU")
            updateLabel.text = "Обновлено: \(formatter.string(from: lastUpdate))"
            cityLabel.text = city
            temperatureLabel.text = "\(temp.roundTo(places: 1))° C"
            descriptionLabel.text = String(description)
            pressureLabel.text = "Давление: \(pressure) гПа"
            humidityLabel.text = "Влажность: \(humidity)%"
            windLabel.text = "Ветер: \(wind.roundTo(places: 1)) м/с"
        }
    }
    
    private func getCity() -> City? {
        if weatherSwitch.isOn {
            return CityData.get(name: "Хабаровск")
        }
        else {
            return CityData.get(name: "Москва")
        }
    }
    
    @objc private func changeValue(sender: UISwitch) {
        if sender.isOn {
            if let city = CityData.get(name: "Хабаровск") {
                configLabels(weather: loadWeatherFromCache(city: city))
                forcastTableView.reloadData()
                downloadDataFromAPI(city: city, loader: false)
                Persistance.shared.city = "Хабаровск"
            }
        }
        else {
            if let city = CityData.get(name: "Москва") {
                configLabels(weather: loadWeatherFromCache(city: city))
                forcastTableView.reloadData()
                downloadDataFromAPI(city: city, loader: true)
                Persistance.shared.city = "Москва"
            }
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as! WeatherTableViewCell
        
        if let city = getCity(),
           let weather = loadWeatherFromCache(city: city)?.daily[indexPath.row + 1],
           let temp = weather.temp,
           let icon = weather.weather.first?.icon {
            cell.configure(date: convertDate(date: weather.unixDate),
                           icon: icon,
                           pressure: "Давление: \(weather.pressure) гПа",
                           humidity: "Влажность: \(weather.humidity)%",
                           wind: "Ветер: \(weather.windSpeed.roundTo(places: 1)) м/с",
                           dayTemp: "\(temp.day.roundTo(places: 1))° C",
                           nightTemp: "\(temp.night.roundTo(places: 1))° C")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 7
    }
}




