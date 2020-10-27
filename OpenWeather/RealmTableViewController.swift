//
//  RealmTableViewController.swift
//  SkillboxLesson14
//
//  Created by Сергей Шопин on 24.10.2020.
//

import UIKit

class RealmTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }

    @IBAction func addAction(_ sender: Any) {
        let alertController = UIAlertController(title: "Создание задачи", message: nil, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Новая задача"
        }
        let alertActionCreate = UIAlertAction(title: "Создать", style: .cancel) { (alert) in
            if let newItem = alertController.textFields?.first?.text, newItem != ""  {
                addItem(nameItem: newItem)
            } else {
                addItem(nameItem: "Новая задача")
            }
            self.tableView.reloadData()
        }
        let alertActionCancel = UIAlertAction(title: "Отмена", style: .default) { (alert) in
            
        }
        alertController.addAction(alertActionCreate)
        alertController.addAction(alertActionCancel)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return toDoItemsRealm?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellRealm", for: indexPath)
        
        if let currentItem = toDoItemsRealm?[indexPath.row] {
            cell.textLabel?.text = currentItem.name
            if currentItem.isComplited {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if changeState(at: indexPath.row) {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            if let toDoList = toDoItemsRealm?[indexPath.row] {
                removeItem(item: toDoList)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }

}
