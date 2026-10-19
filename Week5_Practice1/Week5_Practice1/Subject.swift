import Foundation

class Subject: Identifiable {
    var id: String
    var name: String
    var credits: Int

    init(id: String, name: String, credits: Int) {
        self.id = id
        self.name = name
        self.credits = credits
    }
}
