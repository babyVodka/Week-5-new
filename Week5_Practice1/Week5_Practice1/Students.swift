
import Foundation

class Student: Identifiable {
    var id: String
    var name: String
    var age: Int

    init(id: String, name: String, age: Int) {
        self.id = id
        self.name = name
        self.age = age
    }

    func displayInfo() -> String {
        return "\(id) - \(name), Age: \(age)"
    }
}
