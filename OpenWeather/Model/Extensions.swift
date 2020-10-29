
import Foundation
import RealmSwift

func convertDate(date: Int) -> String {
   let epochDate = Date(timeIntervalSince1970: TimeInterval(date))
   let calendar = Calendar.current
   let currentDay = calendar.component(.day, from: epochDate)
   let currentMonth = calendar.component(.month, from: epochDate)
return "\(currentDay)/\(currentMonth)"
}

extension Double {
   func roundTo(places:Int) -> Double {
       let divisor = pow(10.0, Double(places))
       return (self * divisor).rounded() / divisor
   }
}

func realmWrite(execute: @escaping (_ r: Realm) -> Void) {
    let realm = try! Realm()
    try! realm.write {
        execute(realm)
    }
}

func distinct<T: Equatable>(_ source: [T]) -> [T] {
  var unique = [T]()
  for item in source {
    if !unique.contains(item) {
      unique.append(item)
    }
  }
  return unique
}
