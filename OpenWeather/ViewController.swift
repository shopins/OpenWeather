
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var forcastTableView: UITableView!
    
    @IBOutlet weak var updateLabel: UILabel!
    
    @IBOutlet weak var cityButton: UIButton!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var pressureLabel: UILabel!
    
    @IBOutlet weak var humidityLabel: UILabel!
    
    @IBOutlet weak var windLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        forcastTableView.register(WeatherTableViewCell.nib, forCellReuseIdentifier: WeatherTableViewCell.ident)
   
        let notificationCenter = NotificationCenter.default
            notificationCenter.addObserver(self, selector: #selector(appBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !Persistance.shared.isLoadCities {
            downloadCityDataFromAPI() {
                if Persistance.shared.currentCity == "" {
                    self.cityButton.setTitle("Выберите город", for: .normal)
                    self.performSegue(withIdentifier: "popupCity", sender: nil)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            guard segue.identifier == "popupCity",
                  let destination = segue.destination as? PopUpViewController else { return }
            destination.delegate = self
        }
    
    @objc func appBecomeActive() {
        if let city = getCurrentCity() {
            if let weather = loadWeatherFromCache(cityName: city.name) {
                configLabels(weather: weather)
            }
            downloadWeatherDataFromAPI(city: city)
        }
    }
    
    @IBAction func pressReload(_ sender: UIButton) {
        if let city = getCurrentCity() {
            downloadWeatherDataFromAPI(city: city)
        }
    }
    
    private func downloadWeatherDataFromAPI(city: City) {
            loadWeatherAlamofire(city: city) { weather in
                weather.lastUpdate = Date()
                writeWeatherToCache(weather: markDataWeather(cityName: city.name, weather: weather))
                self.configLabels(weather: weather)
                self.forcastTableView.reloadData()
            }
    }
    
    private func configLabels(weather: Weather) {
        if let temp = weather.current?.temp,
           let description = weather.current?.weather.first?.weatherDescription,
           let pressure = weather.current?.pressure,
           let humidity = weather.current?.humidity,
           let wind = weather.current?.windSpeed
           {
            let formatter = DateFormatter()
                formatter.dateStyle = .long
                formatter.timeStyle = .medium
                formatter.locale = Locale(identifier: "ru_RU")
            updateLabel.text = "Обновлено: \(formatter.string(from: weather.lastUpdate))"
            cityButton.setTitle(weather.city, for: .normal)
            temperatureLabel.text = "\(temp.roundTo(places: 1))° C"
            descriptionLabel.text = description
            pressureLabel.text = "Давление: \(pressure) гПа"
            humidityLabel.text = "Влажность: \(humidity)%"
            windLabel.text = "Ветер: \(wind.roundTo(places: 1)) м/с"
        }
    }
}

extension ViewController: PopUpViewControllerDelegate{
    func changeCity(_ popUpViewController: PopUpViewController, city: City?) {
        if let city = city {
            Persistance.shared.currentCity = city.name
            if let weather = loadWeatherFromCache(cityName: city.name) {
                configLabels(weather: weather)
            }
            forcastTableView.reloadData()
            downloadWeatherDataFromAPI(city: city)
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as! WeatherTableViewCell
        
        if let city = getCurrentCity(),
           let weather = loadWeatherFromCache(cityName: city.name)?.daily[indexPath.row + 1],
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
