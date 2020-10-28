
import UIKit

protocol PopUpViewControllerDelegate {
    func changeCity(_ popUpViewController: PopUpViewController, city: City?)
}

class PopUpViewController: UIViewController {
    

    @IBOutlet weak var cityTableView: UITableView!
    
    @IBAction func editingTextFiled(_ sender: UITextField) {
        if sender.text?.count != 0 {
            filterString = sender.text!
        } else {
            filterString = ""
        }
        subjects = getSubjectsFiltered(filter: filterString)
        cityTableView.reloadData()
        
    }
    
    @IBAction func pressCancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    var delegate: PopUpViewControllerDelegate?
    
    var filterString = ""
    
    var subjects = getSubjectsFiltered(filter: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityTableView.layer.cornerRadius = 10
        cityTableView.layer.masksToBounds = true
    }
        
    @IBOutlet weak var searchTextField: UITextField!
    
}


extension PopUpViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        subjects.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getCitiesNameBySubjectFiltered(subject: subjects[section], filter: filterString).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath)
        let cities = getCitiesNameBySubjectFiltered(subject: subjects[indexPath.section], filter: filterString)
        cell.textLabel?.text = cities[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        subjects[section]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let textLabelText = tableView.cellForRow(at: indexPath)?.textLabel?.text {
            delegate?.changeCity(self, city: loadCityFromCache(cityName: textLabelText))
        }
        
        dismiss(animated: true, completion: nil)
    }
}

extension PopUpViewController: UITextFieldDelegate{
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        filterString = ""
        subjects = getSubjectsFiltered(filter: filterString)
        cityTableView.reloadData()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if searchTextField.text?.count != 0 {
            filterString = searchTextField.text!
            subjects = getSubjectsFiltered(filter: filterString)
        }
        cityTableView.reloadData()
        return true
    }
}
