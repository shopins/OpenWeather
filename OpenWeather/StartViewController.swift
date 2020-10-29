
import UIKit

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        SpinnerActivityIndicator.startAnimating()
        if !Persistance.shared.isLoadCities {
            downloadCityDataFromAPI() { 
                    self.performSegue(withIdentifier: "mainVC", sender: nil)
                    self.SpinnerActivityIndicator.stopAnimating()
            }
        } else {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "mainVC", sender: nil)
                self.SpinnerActivityIndicator.stopAnimating()
            }
        }
    }
    
    @IBOutlet weak var SpinnerActivityIndicator: UIActivityIndicatorView!

}
