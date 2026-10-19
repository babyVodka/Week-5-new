import Foundation

class StudentRecord: Identifiable {
    var id = UUID()
    var student: Student
    var subject: Subject
    private var _mark: Double
    var mark: Double {
        get { _mark }
        set {
            if (0.0...100.0).contains(newValue) {
                _mark = newValue
            }
        }
    }
    
    init(student: Student, subject: Subject, mark: Double) {
        self.student = student
        self.subject = subject
        self._mark = min(100.0, max(0.0, mark))
    }
    
    func isPassed() -> Bool {
        return mark >= 50.0
    }
}
