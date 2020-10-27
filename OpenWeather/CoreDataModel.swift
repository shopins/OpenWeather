
import Foundation
import CoreData
import UIKit

var toDoItemsCoreData : [NSManagedObject] = []
let appDelegate = UIApplication.shared.delegate as! AppDelegate
let managedContext = appDelegate.persistentContainer.viewContext

func addItemCoreData(nameItem: String) {
    let item = NSEntityDescription.insertNewObject(forEntityName: "ToDoItemCore", into: managedContext)
    item.setValue(nameItem, forKey: "name")
    item.setValue(false, forKey: "isComplited")
    toDoItemsCoreData.append(item)
    appDelegate.saveContext()
}

func changeStateCoreData(at index: Int) -> Bool {
    guard let state = toDoItemsCoreData[index].value(forKey: "isComplited") as? Bool else {return false}
    toDoItemsCoreData[index].setValue(!state, forKey: "isComplited")
    appDelegate.saveContext()
    return !state
}

func removeItemCoreData(at index: Int) {
    managedContext.delete(toDoItemsCoreData[index])
    toDoItemsCoreData.remove(at: index)
    appDelegate.saveContext()
}

func loadCoreData() {
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ToDoItemCore")
    do {
        toDoItemsCoreData = try managedContext.fetch(fetchRequest)
    } catch let err as NSError {
        print("Error to fetch", err)
    }
}

