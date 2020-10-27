//
//  ViewController.swift
//  SkillboxLesson12
//
//  Created by Сергей Шопин on 30.09.2020.
//

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
        if let city = CityData.get(name: "Москва") {
            loadRealmData(city: city)
        }
        configLabels()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let city = CityData.get(name: "Москва") {
            loadWeather(city: city, loader: true)
        }
    }
    
    private func loadWeather(city: City?, loader : Bool) {
        if let city = city {
            if loader {
                WeatherLoader().loadStandard(city: city) { weather in
                    markDataWeather(city: city, tempWeather: weather)
                    self.configLabels()
                    self.forcastTableView.reloadData()
                    writeRealmData()
                   }
            } else {
                WeatherLoader().loadAlamofire(city: city) { weather in
                    markDataWeather(city: city, tempWeather: weather)
                    self.configLabels()
                    self.forcastTableView.reloadData()
                    writeRealmData()
                   }
            }
        }
    }

    
    private func configLabels() {
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
    
    @objc func changeValue(sender: UISwitch) {
        if sender.isOn {
            if let city = CityData.get(name: "Хабаровск") {
                loadRealmData(city: city)
                configLabels()
                forcastTableView.reloadData()
                loadWeather(city: city, loader: false)
            }
        }
        else {
            if let city = CityData.get(name: "Москва") {
                loadRealmData(city: city)
                configLabels()
                forcastTableView.reloadData()
                loadWeather(city: city, loader: true)
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
        if let weather = weather?.daily[indexPath.row + 1],
           let temp = weather.temp {
            cell.configure(date: convertDate(date: weather.unixDate),
                           icon: loadImage(icon: weather.weather.first?.icon),
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




