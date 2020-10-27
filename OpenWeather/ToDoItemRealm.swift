
import Foundation
import RealmSwift

@objcMembers class ToDoItemRealm: Object {
    dynamic var name: String = ""
    dynamic var isComplited : Bool = false
}

