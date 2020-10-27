
import Foundation
import RealmSwift

let realm = try! Realm()
var toDoItemsRealm : Results<ToDoItemRealm>?

func addItem(nameItem: String) {
    try! realm.write {
        realm.add(ToDoItemRealm(value:["name":nameItem]))
    }
}

func removeItem(item toDoList: ToDoItemRealm) {
    try! realm.write {
        realm.delete(toDoList)
    }
}

func changeState(at index: Int) -> Bool {
    if let state = toDoItemsRealm?[index].isComplited {
        try! realm.write {
            toDoItemsRealm![index].isComplited = !state
        }
        return !state
    }
    return false
}

func loadData() {
    toDoItemsRealm = realm.objects(ToDoItemRealm.self)
}



