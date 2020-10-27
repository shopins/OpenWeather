//
//  FirstViewController.swift
//  SkillboxLesson14
//
//  Created by Сергей Шопин on 07.10.2020.
//

import UIKit


class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.text = Persistance.shared.userName
        surnameTextField.text =  Persistance.shared.userSurname
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var surnameTextField: UITextField!
    
    @IBAction func editingName(_ sender: UITextField) {
        Persistance.shared.userName = nameTextField.text ?? ""
    }
    
    @IBAction func editingSurname(_ sender: UITextField) {
        Persistance.shared.userSurname = surnameTextField.text ?? ""
    }

}
