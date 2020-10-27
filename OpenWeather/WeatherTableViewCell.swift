import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    static let ident = "WeatherTableViewCell"
    static let nib = UINib(nibName: "WeatherTableViewCell", bundle: nil)
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var dayTempLabel: UILabel!
    @IBOutlet weak var nightTempLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var nightLabel: UILabel!

    public func configure(date: String,
                          icon: UIImage?,
                          pressure: String,
                          humidity: String,
                          wind: String,
                          dayTemp: String,
                          nightTemp: String) {
        dateLabel.text = date
        pressureLabel.text = pressure
        humidityLabel.text = humidity
        windLabel.text = wind
        dayLabel.text = "днем"
        dayTempLabel.text = dayTemp
        nightLabel.text = "ночью"
        nightTempLabel.text = nightTemp
        weatherImageView.image = icon
    }
    
}
