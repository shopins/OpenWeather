
import UIKit

protocol PopUpViewControllerDelegate {
    func changeCity(_ popUpViewController: PopUpViewController, city: City?)
}

class PopUpViewController: UIViewController {

    @IBOutlet weak var cityTableView: UITableView!
    
    @IBAction func pressCancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    var delegate: PopUpViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityTableView.layer.cornerRadius = 10
        cityTableView.layer.masksToBounds = true
    }

}

extension PopUpViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath)
        cell.textLabel?.text = cities[indexPath.row]?.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.changeCity(self,city: cities[indexPath.row])
        dismiss(animated: true, completion: nil)
    }
}
